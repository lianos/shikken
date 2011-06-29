## setClass("SupervisedLearningMachine", contains="LearningMachine")
## setClass("UnsupervisedLearningMachine", contains="LearningMachine")

supportedMachineTypes <- function() {
  # c('classification', '2-class', '1-class', 'multi-class', 'regression')
  c('classification', '2-class', 'regression')
}

matchLearningType <- function(labels, learning.type) {
  if (missing(learning.type) || is.null(learning.type)) {
    if (missing(labels) || is.null(labels)) {
      stop("Labels required to guess learning type")
    }
    learning.type <- guessLearningTypeFromLabels(labels)
  }
  
  learning.type <- match.arg(learning.type, supportedMachineTypes())
  
  if (learning.type == 'classification') {
    learning.type <- '2-class'
  }
  
  learning.type
}

isClassificationMachine <- function(x, ...) {
  stopifnot(inherits(x, 'LearningMachine'))
  length(grep('class', x@type) > 0L)
}

isRegressionMachine <- function(x, ...) {
  stopifnot(inherits(x, 'LearningMachine'))
  length(grep('regress', x@type) > 0L)
}

setMethod("fitted", "KernelMachine", function(object, ...) {
  predict(object, newdata=NULL, type="response")
})

setMethod("coef", "KernelMachine", function(object, ...) {
  stop("Implement coef,KernelMachine")
})

setMethod("predict", "KernelMachine",
function(object, newdata=NULL, type="response", ...) {
  type <- match.arg(type, c("response", "decision", "probabilities"))
  if (!object@is.trained) {
    stop("You've found yourself with an untrained machine, ",
         "build a new one and try again.")
  }
  if (type == "probabilities") {
    stop("probabilities not yet supported")
  }
  
  if (!is.null(newdata)) {
    newdata <- as(newdata, 'Features')@sg.ptr
  }
  
  ## If shogun threads are > 1, we get following error:
  ## `Error: C stack usage is too close to the limit`
  old.threads <- threads()
  threads(1L)
  on.exit(threads(old.threads))
  
  ## Returns the decision values
  preds <- .Call("svm_predict", object@sg.ptr, newdata, PACKAGE="shikken")
  
  if (type == "response" && isClassificationMachine(object)) {
    preds <- sign(preds)
  }
  
  preds
})

