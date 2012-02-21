## TODO: Implement trained() logical method on static learning machines

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
  length(grep('class', x) > 0L)
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

setMethod("coef", "SupportVectorMachine", function(object, ...) {
  sign(alpha(object))
})

setMethod("predict", "SupportVectorMachine",
function(object, newdata=NULL, type="response", ...) {
  type <- match.arg(type, c("response", "decision", "probabilities"))
  if (type == "probabilities") {
    stop("probabilities not yet supported")
  }
  
  if (!is.null(newdata)) {
    initKernel(newdata, kernel=object@kparams$key, svm.params=object@params,
               target='test', do.clean=FALSE)
  }
  
  ## Returns the decision values
  preds <- sgg('classify')
  if (type == "response" && isClassificationMachine(object)) {
    fmap <- object@params$labels@factor.map
    if (length(fmap)) {
      preds <- factor(fmap[as.character(preds)], levels=fmap)
    } else if (object@type == '2-class') {
      preds <- sign(preds)
    }
  }
  
  preds
})

