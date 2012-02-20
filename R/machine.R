supportedMachineTypes <- function() {
  # c('classification', '2-class', '1-class', 'multi-class', 'regression')
  c('1-class', '2-class', 'multi-class', 'regression')
}

isClassificationMachine <- function(x, ...) {
  if (inherits(x, 'Machine')) {
    x <- x@type
  }
  if (inherits(x, 'Labels')) {
    x <- tolower(class(x)[1L])
  }
  if (!is.character(x)) {
    stop("x needs to be a Machine or character")
  }
  length(grep('class', x@type) > 0L)
}

isRegressionMachine <- function(x, ...) {
  if (inherits(x, 'Labels')) {
    return(!isClassificationMachine(x))
  }
  if (inherits(x, 'Machine')) {
    x <- x@type
  }
  if (!is.character(x)) {
    stop("x needs to be a Machine or character")
  }
  length(grep('regress', x) > 0L)
}

setMethod("trained", c(x="Machine"),
function(x, ...) {
  x@cache[['trained']]
})

setReplaceMethod("trained", "Machine", function(x, value) {
  stopifnot(isTRUEorFALSE(value))
  if (value) {
    stop("You cannot declare a machine as being `trained`, ",
         "run `train(x, ...)")
  }
  x@cache[['trained']] <- FALSE
  x
})

setMethod("threads", c(x="Machine"),
function(x, ...) {
  x@num.threads
})

setReplaceMethod("threads", "Machine", function(x, value) {
  value <- as.integer(value)
  stopifnot(isSingleInteger(x))
  
  n.cores <- detectCores()
  if (n.cores < value) {
    warning("Number of cores is less than the number of threads desired, ",
            "setting number of threads to max cores")
    value <- n.cores
  }
  
  x@num.threads <- value
  x
})

setMethod("fitted", "KernelMachine", function(object, ...) {
  predict(object, newdata=NULL, type="response")
})

setMethod("coef", "KernelMachine", function(object, ...) {
  stop("Implement coef,KernelMachine")
})

setMethod("predict", "Machine",
function(object, newdata=NULL, type="response", ...) {
  type <- match.arg(type, c("response", "decision", "probabilities"))
  if (!trained(object)) {
    stop("You've found yourself with an untrained machine, ",
         "build a new one and try again.")
  }
  if (type == "probabilities") {
    stop("probabilities not yet supported")
  }
  
  if (!is.null(newdata)) {
    if (!inherits(newdata, 'Features')) {
      features <- Features(newdata, object@kernel)
    }
    newdata <- features@sg.ptr
  }
  
  ## If shogun threads are > 1, we get following error:
  ## `Error: C stack usage is too close to the limit`
  old.threads <- threads()
  threads(1L)
  on.exit(threads(old.threads))
  
  ## Returns the decision values
  preds <- .Call(predict.fn(object), object, newdata, PACKAGE="shikken")
  if (type == "response" && isClassificationMachine(object)) {
    preds <- sign(preds)
  }
  
  preds
})

