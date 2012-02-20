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

setMethod("SVM", c(x="vector"),
function(x, ...) {
  SVM(as.matrix(x), ...)
})

setMethod("SVM", c(x="XStringSet"),
function(x, y=NULL, kernel="spectrum", ...) {
  SVM(as.character(x), y=y, kernel=kernel, ...)
})

setMethod("SVM", c(x="character"),
function(x, y=NULL, kernel="spectrum", ...) {
  initStringKernel(as.matrix(x), kernel=kernel, ...)
  initSVM(...)
})

## TODO: Multiple kernel learning when x is a list
setMethod("SVM", c(x="list"),
function(x, ...) {
  
})

setMethod("SVM", c(x="matrix"),
function(x, y=NULL, kernel="linear", kparams="automatic", type=NULL,
         svm.engine=c('libsvm', 'svmlight'), scaled=TRUE, C=1, C.neg=C,
         nu=0.2, epsilon=0.1, class.weights=NULL, cache=40, threads=1L,
         preproc=NULL, normalizer=NULL, ..., subset, na.action=na.omit,
         do.train=TRUE) {
  if (missing(y) || is.null(y)) {
    stop("Labels (y) is required.")
  }
  
  if (nrow(x) != length(y)) {
    stop("Number of observations does not equal number of labels")
  }
  
  initSvm(y, type=type, svm.engine=svm.engine, C=C, C.neg=C.neg,
          nu=nu, epsilon=epsilon, class.weights=class.weights,
          cache=cache, threads=threads)
  
  initKernel(x, kernel, 'train', preproc=preproc, normalizer=normalizer, ...,
             scaled=scaled)
  ## ...
  if (length(grep("class", type)) {
    sg('train_classifier')
  } else {
    sg('train_regression')
  }
  
    train.cmd <- 'train_classifer'
  } else if (type == )
  train.cmd <- sw
  if (type == "2-class") {
    
  }
  sg('train_classifier')
  
  kernel <- Kernel(x, kernel=kernel, scaled=scaled, ...)
  labels <- Labels(y, type)
  
  
  sg.ptr <- .Call("svm_init", kernel@sg.ptr, labels@sg.ptr, C, epsilon,
                  svm.engine)
  
  if (is.null(sg.ptr)) {
    stop("error occured while initializing svm")
  }
  
  svm <- new("SVM", sg.ptr=sg.ptr, kernel=kernel, labels=labels, type=type,
             engine=svm.engine, num.threads=n.threads)
             
  svm@cache[['trained']] <- FALSE
  svm@cache[['epsilon']] <- epsilon
  svm@cache[['C']] <- C
  
  if (do.train) {
    train(svm)
  }
  
  svm
})

initSvm <- function(y, type=NULL, svm.engine='libsvm',
                    C=1, C.neg=C, nu=0.2, epsilon=0.1, class.weights=NULL,
                    cache=40, threads=1L, ...) {
  if (is.null(type)) {
    type <- guessLearningTypeFromLabels(y)
  }
  type <- match.arg(type, supportedMachineTypes())
  
  svm.engine <- matchSvmEngine(svm.engine)
  
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
  
  threads <- as.integer(threads)
  if (!isSingleInteger(epsilon)) {
    stop("N threads must be a single integer")
  }
  threads(threads)
  
}

setMethod("SVM", c(x="Features"),
function(x, ...) {
  kernel <- Features(x, ...)
  SVM(kernel, ...)
})

setMethod("SVM", c(x="Kernel"),
function(x, ...) {

})

setMethod("train", c(x="SVM"),
function(x, ...) {
  if (!trained(x)) {
    .Call(train.fn(x), x, PACKAGE="shikken")
  }
  x@cache[['trained']] <- TRUE
  invisible(x)
})

setMethod("objective", c(x="SVM"),
function(x, ...) {
  .Call("svm_objective", x@sg.ptr, PACKAGE="shikken")
})

###############################################################################
## Delegating to C
setMethod("train.fn", c(x="SVM"),
function(x, ...) {
  "svm_train"
})

setMethod("predict.fn", c(x="SVM"),
function(x, ...) {
  ## by and large, we use the predict (apply) method from KernelMachine,
  ## but let's check for special cases
  fn <- switch(x@engine, scattersvm='scattersvm_predict',
               'kmachine_predict')
  fn
})
