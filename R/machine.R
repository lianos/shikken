## setClass("SupervisedLearningMachine", contains="LearningMachine")
## setClass("UnsupervisedLearningMachine", contains="LearningMachine")

supportedMachineTypes <- function() {
  # c('classification', '2-class', '1-class', 'multi-class', 'regression')
  c('classification', '2-class', 'regression')
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
  
  preds <- .Call("svm_predict", object@sg.ptr, newdata, PACKAGE="shikken")
  
  if (type == "decision") {
    preds <- sign(preds)
  }
  
  preds
})