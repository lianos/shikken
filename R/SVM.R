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
function(x, data=NULL, ..., subset, na.action=na.omit, do.scale=TRUE) {
  warning("You will have to manually manipulate things you want to predict ",
          "on into a matrix")
  cl <- match.call()
  m <- match.call(expand.dots=FALSE)
  if (is.matrix(eval(m$data, parent.frame()))) {
    m$data <- as.data.frame(data)
  }
  m$... <- NULL
  m$formula <- m$x
  m$x <- NULL
  m$do.scale <- NULL
  m[[1]] <- as.name("model.frame")
  m <- eval(m, parent.frame())
  Terms <- attr(m, "terms")
  attr(Terms, "intercept") <- 0    ## no intercept

  x <- model.matrix(Terms, m)
  y <- model.extract(m, response)

  if (length(do.scale) == 1) {
    do.scale <- rep(do.scale, ncol(x))
  }
  if (any(do.scale)) {
    remove <- unique(c(which(labels(Terms) %in% names(attr(x, "contrasts"))),
                       which(!do.scale)))
    scaled <- !attr(x, "assign") %in% remove
  }

  ret <- SVM(x, y, do.scale=do.scale, ...)
  # kcall(ret) <- cl
  # attr(Terms,"intercept") <- 0 ## no intercept
  # terms(ret) <- Terms

  if (!is.null(attr(m, "na.action"))) {
    n.action(ret) <- attr(m, "na.action")
  }

  ret
})

setMethod("SVM", c(x="numeric"),
function(x, y=NULL, ...) {
  SVM(as.matrix(x), y=y, ...)
})

findIllegalStringChars <- function(x, kosher=c('A', 'C', 'G', 'T')) {
  if (is.character(x)) {
    x <- DNAStringSet(x)
  }
  stopifnot(inherits(x, 'XStringSet'))
  nt.distro <- alphabetFrequency(x)
  illegal.cols <- !colnames(nt.distro) %in% kosher
  which(rowSums(nt.distro[, illegal.cols]) > 0)
}

setMethod("SVM", c(x="XStringSet"),
function(x, y=NULL, kernel="spectrum", ...) {
  stopifnot(inherits(x, 'DNAStringSet'))
  bad.x <- findIllegalStringChars(x)
  ## Ensure that there are only ACGT in the alphabet
  if (length(bad.x)) {
    warning("There are sequences in X that have nucleotides outside of ",
            "ACGT.\nTheir indices have been returned from this function call.\n",
            "Please remove these examples from your dataset and try again.")
    return(bad.x)
  }
  SVM(as.matrix(as.character(x)), y=y, kernel=kernel, do.char.check=FALSE, ...)
})

setMethod("SVM", c(x="character"),
function(x, y=NULL, kernel="spectrum", x.isfile=FALSE,
         do.char.check=TRUE, ...) {
  if (x.isfile) {
    stop("TODO: Support file feature input")
  }
  if (do.char.check) {
    bad.x <- findIllegalStringChars(x)
    if (length(bad.x)) {
      warning("There are sequences in X that have nucleotides outside of ",
              "ACGT.\nTheir indices have been returned from this function call.\n",
              "Please remove these examples from your dataset and try again.")
      return(bad.x)
    }
  }
  SVM(as.matrix(x), y=y, kernel=kernel, ...)
})

setMethod("SVM", c(x="matrix"),
function(x, y=NULL, kernel="linear", do.train=TRUE, ...) {
  if (is.null(y)) {
    stop("y is required")
  }
  if (nrow(x) != length(y)) {
    stop("Number of observations doesn't equal number of labels")
  }
  
  if (is.character(kernel)) {
    kernel <- matchKernelType(kernel)
  }
  
  params <- initSVM(x, y, kernel, ...)
  kparams <- initKernel(x, kernel=kernel, svm.params=params,
                        target='train', do.clean=TRUE, ...)

  if (do.train) {
    svm <- trainSVM(params, kparams)
  } else {
    svm <- new(Class="SVM", params=params, kparams=kparams)
  }

  svm
})

## TODO: Wire up Multiple kernel learning when calling SVM with is.list(x)
##       Look at mkl_classify_christmas_star to see how it's done
setMethod("SVM", c(x="list"),
function(x, ...) {
  stop("Multiple Kernel Learning not yet implemented")
})

setMethod("show", c(object="SVM"),
function(object) {
  cat(object@type, "SVM with", object@kparams$key, "kernel\n")
  cat(" ", object@nSV, " support vectors\n\n")
  cat(" SVM parameters:\n")
  for (name in names(object@params)) {
    if (!name %in% c('cache', 'labels')) {
      val <- object@params[[name]]
      if (is.numeric(val)) {
        cat(sprintf("    %s: %.2f\n", name, val))
      } else {
        cat(sprintf("    %s: %s\n", name, val))
      }
    }
  }

  cat("\n  Kernel parameters:\n")
  for(name in names(object@kparams$params)) {
    if (!name %in% c('key', 'x.dim')) {
      val <- object@kparams$params[[name]]
      if (is.numeric(val)) {
        cat(sprintf("    %s: %.2f\n", name, val))
      } else {
        cat(sprintf("    %s: %s\n", name, val))
      }
    }
  }
  cat("\n")
})

##' This initializes a new SVM instance.
##'
##' Everything that has been stored in the static shogun machine will be
##' blown out
initSVM <- function(x, y, kernel, type=NULL, svm.engine='libsvm',
                    C=1, C.neg=C, nu=0.2, epsilon=0.1, class.weights=NULL,
                    threads=1L, use.bias=NULL, ...) {
  if (missing(y) || is.null(y) || any(is.na(y) || any(is.null(y)))) {
    stop("Labels (y) is required and can't have missing labels")
  }
  
  if (is.character(kernel)) {
    kernel <- matchKernelType(kernel)
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
  
  if (is.null(use.bias)) {
    use.bias <- isClassificationMachine(type) && kernel == 'linear'
  }
  
  svm.engine <- matchSvmEngine(svm.engine)

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

  use.bias <- as.logical(use.bias)[1L]
  if (!isTRUEorFALSE(use.bias)) {
    stop("Illegal value for use.bias, logical(1) required")
  }

  ## ---------------------------------------------------------------------------
  ## Do the sg initialization
  sgg('clean_features', 'TRAIN')
  sgg('clean_features', 'TEST')
  sgg('clean_kernel')
  sgg('set_labels', 'TRAIN', y@y)

  if (isClassificationMachine(type)) {
    if (class(y) == "OneClassLabels") {
      sgg('svm_nu', nu)
      sg.machine <- 'LIBSVM_ONECLASS'
    } else if (class(y) == "TwoClassLabels") {
      if (missing(C.neg)) {
        sgg('c', C)
      } else {
        sgg('c', C, C.neg)
      }
      sg.machine <- toupper(svm.engine)
    } else if (class(y) == "MultiClassLabels") {
      sgg('c', C)
      sg.machine <- 'LIBSVM_MULTICLASS'
    } else {
      stop("Can't reconcile value for sgg('new_classifier', ...)")
    }

    sgg('new_classifier', sg.machine)
    sgg('svm_epsilon', epsilon)
  } else {
    sg.machine <- switch(engine,
                         libsvm="LIBSVR",
                         svmlight="SVRLIGHT",
                         stop("Illegal engine for sgg('new_regression', ...)"))
    sgg('new_regression', sg.machine)
    sgg('c', C)
    sgg('svr_tube_epsilon', epsilon)
  }

  sgg('svm_use_bias', use.bias)

  list(labels=y, type=type, engine=svm.engine, C=C, C.neg=C.neg,
       use.bias=use.bias, epsilon=epsilon, nu=nu, sg.machine=sg.machine)
}

trainSVM <- function(svm.params, kparams) {
  x <- match.arg(svm.params$type, supportedMachineTypes())
  if (isClassificationMachine(x)) {
    sgg('train_classifier')
  } else if (isRegressionMachine(x)) {
    sgg('train_regression')
  } else {
    stop("don't know how to train machine type: ", x)
  }

  if (svm.params$type == 'multi-class') {
    warning("No objective, alphas, or SV info provided from multi-class SVM")
    bias <- double()
    alpha <- double()
    sv.index <- integer()
    objective <- double()
  } else {
    svm <- sgg('get_svm')
    bias <- if (svm.params$use.bias) svm[[1L]][1L] else double()
    alpha <- svm[[2L]][,1L]
    sv.index <- as.integer(svm[[2L]][,2L]) + 1L
    objective <- sgg('get_svm_objective')
  }

  new(Class="SVM",
      engine=svm.params$engine, type=svm.params$type, bias=bias,
      C=svm.params$C, C.neg=svm.params$C.neg, alpha=alpha, nSV=length(alpha),
      SVindex=sv.index, objective=objective, params=svm.params,
      kparams=kparams)
}

###############################################################################
## Utility functions
setMethod("predict", "SVM",
function(object, newdata, type="response", decision.split=0, ...) {
  if (missing(newdata) || is.null(newdata)) {
    stop("shikken machines need `newdata` to predict on")
  }
  type <- match.arg(type, c("response", "decision", "probabilities"))
  if (type == "probabilities") {
    stop("probabilities not yet supported")
  }
  
  if (object@kparams$feature.type == 'string') {
    bad.x <- findIllegalStringChars(newdata)
    if (length(bad.x)) {
      warning("There are sequences in newdata that have nucleotides outside of ",
              "ACGT.\nTheir indices have been returned from this function call.\n",
              "Please remove these examples from your dataset and try again.")
      return(bad.x)
    }
  }

  if (!is.null(newdata)) {
    initKernel(newdata, kernel=object@kparams$key, svm.params=object@params,
               target='test', do.clean=FALSE)
  }

  ## Returns the decision values
  preds <- sgg('classify')

  if (type == "response" && isClassificationMachine(object)) {
    if (object@type == '2-class') {
      neg.class <- preds < decision.split
      preds[neg.class] <- -1
      preds[!neg.class] <- 1
    }
    fmap <- object@params$labels@factor.map
    if (length(fmap)) {
      xref <- match(preds, fmap)
      preds <- factor(names(fmap)[xref], levels=names(fmap))
    }
  }

  preds
})

setMethod("coef", "SVM", function(object, ...) {
  object@alpha
})

setMethod("objective", c(x="SVM"),
function(x, ...) {
  x@objective
})

setMethod("bias", c(x="SVM"),
function(x, ...) {
  x@bias
})

setMethod("alpha", c(object="SVM"),
function(object) {
  abs(object@alpha)
})

setGeneric("supportVectors", function(x, dat, as.index=FALSE, ...) {
  standardGeneric("supportVectors")
})

setMethod("supportVectors", c(x="SVM"),
function(x, dat, as.index, ...) {
  if (missing(dat) && !as.index) {
    stop("Can't retrieve support vectors w/o `dat`")
  }
  ans <- SVindex(x)
  if (!as.index) {
    ans <- dat[ans,]
  }
  ans
})

setMethod("SVindex", c(object="SVM"),
function(object) {
  object@SVindex
})

setMethod("nSV", c(object="SVM"),
function(object) {
  object@nSV
})
