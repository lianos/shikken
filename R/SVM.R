matchSvmEngine <- function(engine, as.int=FALSE) {
  ## These 'engines' strings should match match 1-for-1/exact (case and all)
  ## with the engines-mathcing code in svm.cpp::match_svm_engine

  engines <- c('libsvm', 'svmlight')
  engine <- match.arg(engine, engines)
  if (as.int) {
    engine <- match(engine, engines)
  }
  engine
}

setValidity("SupportVectorMachine", function(object) {
  errs <- character()
  engine.ok <- tryCatch(matchSvmEngine(object@engine), error=function(e) NULL)
  if (is.null(engine.ok)) {
    errs <- paste(errs, "Unknown SVM engine/solver: ", object@engine)
  }

  if (length(errs) == 0L) TRUE else errs
})

setGeneric("SVM", function(x, ...) standardGeneric("SVM"))
setMethod("SVM", c(x="formula"),
function(x, data=NULL, ..., subset, na.action=na.omit, scaled=TRUE) {
  cl <- match.call()
  m <- match.call(expand.dots=FALSE)
  if (is.matrix(eval(m$data, parent.frame()))) {
    m$data <- as.data.frame(data)
  }
  m$... <- NULL
  m$formula <- m$x
  m$x <- NULL
  m$scaled <- NULL
  m[[1]] <- as.name("model.frame")
  m <- eval(m, parent.frame())
  Terms <- attr(m, "terms")
  attr(Terms, "intercept") <- 0    ## no intercept

  x <- model.matrix(Terms, m)
  y <- model.extract(m, response)

  if (length(scaled) == 1) {
    scaled <- rep(scaled, ncol(x))
  }
  if (any(scaled)) {
    remove <- unique(c(which(labels(Terms) %in% names(attr(x, "contrasts"))),
                       which(!scaled)))
    scaled <- !attr(x, "assign") %in% remove
  }

  ret <- SVM(x, y, scaled=scaled, ...)
  # kcall(ret) <- cl
  # attr(Terms,"intercept") <- 0 ## no intercept
  # terms(ret) <- Terms

  if (!is.null(attr(m, "na.action"))) {
    n.action(ret) <- attr(m, "na.action")
  }

  ret
})

setMethod("SVM", c(x="numeric"),
function(x, ...) {
  SVM(as.matrix(x), ...)
})

setMethod("SVM", c(x="XStringSet"),
function(x, y=NULL, kernel="spectrum", ...) {
  SVM(as.matrix(as.character(x)), y=y, kernel=kernel, ...)
})

setMethod("SVM", c(x="character"),
function(x, y=NULL, kernel="spectrum", x.isfile=FALSE, ...) {
  if (x.isfile) {
    stop("TODO: Support file feature input")
  }
  SVM(as.matrix(x), y=y, kernel=kernel, ...)
})

setMethod("SVM", c(x="matrix"),
function(x, y=NULL, kernel="linear", ...) {
  params <- initSVM(y, ...)
  kparams <- initKernel(x, kernel=kernel, svm.params=params,
                        target='train', do.clean=TRUE, ...)

  trainSVM(params)

  svm <- sgg('get_svm')
  if (params$type == 'multi-class') {
    stop("Multiclass classification not fully implemented")
  }

  bias <- svm[[1L]]
  alpha <- svm[[2L]][,1L]
  sv.index <- as.integer(svm[[2L]][,2L] + 1L)

  ans <- new("SupportVectorMachine",
             engine=params$engine, type=params$type, C=params$C,
             C.neg=params$C.neg, alpha=alpha, nSV=length(alpha),
             SVindex=sv.index, params=params, kparams=kparams)
  ans
})

## TODO: Wire up Multiple kernel learning when calling SVM with is.list(x)
setMethod("SVM", c(x="list"),
function(x, ...) {
  stop("Multiple Kernel Learning not yet implemented")
})

initSVM <- function(y, type=NULL, svm.engine='libsvm',
                    C=1, C.neg=C, nu=0.2, epsilon=0.1, class.weights=NULL,
                    cache=40, threads=1L, use.bias=TRUE, ...) {
  if (missing(y) || is.null(y)) {
    stop("Labels (y) is required")
  }

  y <- Labels(y, type, ...)
  gtype <- guessMachineTypeFromLabels(y)
  if (is.character(type)) {
    if (gtype != type) {
      stop("Specfied machine type doesn't match labels")
    }
  } else {
    type <- gtype
  }

  svm.engine <- matchSvmEngine(svm.engine)

  ## SVMLIGHT can only to 2-class classification here?
  if (svm.engine == "svmlight") {
    if (isClassificationMachine(type) && !is(y, 'TwoClassLabels')) {
      stop("Using SVMLight for classification only accepts 2-class labels ",
           "try libsvm")
    }
  }

  C <- as.double(C)
  if (!isSingleDouble(C)) {
    stop("Illegal value for C")
  }

  C.neg <- as.double(C.neg)
  if (!isSingleDouble(C.neg)) {
    stop("Illegal value for C.neg")
  }

  epsilon <- as.numeric(epsilon)
  if (!isSingleDouble(epsilon)) {
    stop("Illegal value for epsilon")
  }

  if (!missing(nu) && !is(y, 'OneClassLabels')) {
    warning("Only C-svm supported for > 1-clas learning")
  }
  nu <- as.numeric(nu)
  if (!isSingleDouble(nu)) {
    stop("Illegal value for nu")
  }

  threads <- as.integer(threads)
  if (!isSingleInteger(threads)) {
    stop("N threads must be a single integer")
  }
  shThreads(threads)

  ## cache is really an integer, but passed along as numeric
  cache <- as.numeric(as.integer(cache))
  if (!isSingleDouble(cache)) {
    stop("Illegal value for cache")
  }

  use.bias <- as.logical(use.bias)[1L]
  if (!isTRUEorFALSE(use.bias)) {
    stop("Illegal value for use.bias, logical(1) required")
  }

  ## ---------------------------------------------------------------------------
  ## Do the sg initialization
  sgg('clean_features', 'TRAIN')
  sgg('clean_features', 'TEST')
  sgg('set_labels', 'TRAIN', y@y)

  if (isClassificationMachine(type)) {
    if (class(y) == "OneClassLabels") {
      sgg('svm_nu', nu)
      sg.machine <- 'LIBSVM_ONECLASS'
    } else if (class(y) == "TwoClassLabels") {
      sgg('c', C, C.neg)
      sg.machine <- toupper(svm.engine)
    } else if (class(y) == "MultiClassLabels") {
      sgg('c', C)
      sg.machine <- 'LIBSVM_MULTICLASS'
    } else {
      stop("Can't reconcile value for sgg('new_classifier', ...)")
    }

    sgg('new_classifier', sg.machine)
    sgg('svm_epsilon', epsilon)
    sgg('svm_use_bias', use.bias)
  } else {
    sg.machine <- switch(engine,
                        libsvm="LIBSVR",
                        svmlight="SVRLIGHT",
                        stop("Can't reconcile vale for sgg('new_regression', ...)"))
    sgg('new_regression', sg.machine)
    sgg('c', C)
    sgg('svr_tube_epsilon', epsilon)
  }

  list(labels=y, type=type, engine=svm.engine, C=C, C.neg=C.neg,
       epsilon=epsilon, nu=nu, cache=cache, sg.machine=sg.machine)
}

trainSVM <- function(svm.params) {
  x <- match.arg(svm.params$type, supportedMachineTypes())
  if (isClassificationMachine(x)) {
    sgg('train_classifier')
  } else if (isRegressionMachine(x)) {
    sgg('train_regression')
  } else {
    stop("don't know how to train machine type: ", x)
  }
  invisible(NULL)
}

