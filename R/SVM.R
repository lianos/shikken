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

setValidity("SVM", function(object) {
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
  SVM(as.character(x), y=y, kernel=kernel, ...)
})

setMethod("SVM", c(x="character"),
function(x, y=NULL, kernel="spectrum", ...) {
  params <- initSVM(y, ...)
  initStringKernel(as.matrix(x), kernel=kernel, params$cache, ...)

  train(params$type)

  alpha <- numeric()
  sv.index <- integer()

  ans <- with(params, {
    new("SVM", engine=engine, C=C, C.neg=C.neg, alpha=alpha,
        nSV=length(alpha), SVindex=sv.index)
  })
  ans
})

setMethod("SVM", c(x="matrix"),
function(x, y=NULL, kernel="linear", ...) {
  params <- initSVM(y, ...)
  initNumericKernel(x, kernel=kernel, params$cache, ...)

  train(params$type)

  alpha <- numeric()
  sv.index <- integer()

  ans <- with(params, {
    new("SVM", engine=engine, C=C, C.neg=C.neg, alpha=alpha,
        nSV=length(alpha), SVindex=sv.index)
  })
  ans
})

## TODO: Wire up Multiple kernel learning when calling SVM with is.list(x)
setMethod("SVM", c(x="list"),
function(x, ...) {
  stop("Multiple Kernel Learning not yet implemented")
})

initSvm <- function(y, type=NULL, svm.engine='libsvm',
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

  C <- as.numeric(C)
  if (!isSingleNumber(C)) {
    stop("Illegal value for C")
  }

  C.neg <- as.numeric(C.neg)
  if (!isSingleNumber(C.neg)) {
    stop("Illegal value for C.neg")
  }

  epsilon <- as.numeric(epsilon)
  if (!isSingleNumber(epsilon)) {
    stop("Illegal value for epsilon")
  }

  if (!missing(nu) && !is(y, 'OneClassLabels')) {
    warning("Only C-svm supported for > 1-clas learning")
  }
  nu <- as.numeric(nu)
  if (!isSingleNumber(nu)) {
    stop("Illegal value for nu")
  }

  threads <- as.integer(threads)
  if (!isSingleInteger(epsilon)) {
    stop("N threads must be a single integer")
  }
  threads(threads)

  ## cache is really an integer, but passed along as numeric
  cache <- as.numeric(as.integer(cache))
  if (!isSingleNumber(cache)) {
    stop("Illegal value for cache")
  }

  use.bias <- as.logical(use.bias)[1L]
  if (!isTRUEorFALSE(use.bias)) {
    stop("Illegal value for use.bias, logical(1) required")
  }

  ## ---------------------------------------------------------------------------
  ## Do the sg initialization
  sg('set_labels', 'TRAIN', y@y)

  if (isClassificationMachine(type)) {
    if (class(y) == "OneClassLabels") {
      sg('svm_nu', nu)
      sg.machine <- 'LIBSVM_ONECLASS'
    } else if (class(y) == "TwoClassLabels") {
      sg('c', c(C, C.neg))
      sg.machine <- toupper(engine)
    } else if (class(y) == "MultiClassLabels") {
      sg('c', C)
      sg.machine <- 'LIBSVM_MULTICLASS'
    } else {
      stop("Can't reconcile value for sg('new_classifier', ...)")
    }

    sg('new_classifier', sg.machine)
    sg('svm_epsilon', epsion)
    sg('svm_use_bias', use.bias)
  } else {
    sg.machine <- switch(engine,
                        libsvm="LIBSVR",
                        svmlight="SVRLIGHT",
                        stop("Can't reconcile vale for sg('new_regression', ...)"))
    sg('new_regression', sg.machine)
    sg('c', C)
    sg('svr_tube_epsilon', epsilon)
  }

  list(labels=y, type=type, engine=svm.engine, C=C, C.neg=C.neg,
       epsilon=epsilon, nu=nu, cache=cache, sg.machine=machine)
}


setMethod("train", c(x="character"),
function(x, ...) {
  x <- match(x, supportedMachineTypes())
  if (isClassificationMachine(x)) {
    sg('train_classifier')
  } else if (isRegressionMachine(x)) {
    sg('train_regression')
  } else {
    stop("don't know how to train machine type: ", x)
  }
  invisible(NULL)
})

