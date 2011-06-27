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

setMethod("fitted", "KernelMachine", function(object, ...) {
  predict(object, newdata=NULL, type="response")
})

setMethod("coef", "KernelMachine", function(object, ...) {
  stop("Implement coef,KernelMachine")
})

setMethod("predict", "KernelMachine",
function(object, newdata=NULL, type="response", ...) {
  type <- match.arg(type, c("response", "decision", "probabilities"))
  if (type == "probabilities") {
    stop("probabilities not yet supported")
  }
  
  if (!is.null(newdata)) {
    newdata <- as(newdata, 'Features')@sg.ptr
  }
  
  ## If shogun threads are > 1, we get following error:
  ## `Error: C stack usage is too close to the limit`
  old.threads <- threads()
  
  ## Returns the decision values
  preds <- .Call("svm_predict", object@sg.ptr, newdata, PACKAGE="shikken")
  
  threads(old.threads)
  
  if (type == "response") {
    preds <- sign(preds)
  }
  
  preds
})

