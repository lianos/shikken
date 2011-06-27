guessLearningTypeFromLabels <- function(labels) {
  nlevels <- length(unique(labels))
  if (nlevels == 0) {
    stop("At least one level is required in your labels/factor.")
  } else if (nlevels == 1) {
    learning.type <- '1-class'
  } else if (nlevels == 2) {
    learning.type <- '2-class'
  } else {
    if (is.factor(labels)) {
      learning.type <- 'multi-class'
    } else {
      learning.type <- 'regression'
    }
  }
  learning.type
}

createLabels <- function(y, learning.type=NULL, ...) {
  learning.type <- matchLearningType(y, learning.type)
  is.classification <- length(grep('class', learning.type)) > 0L
  
  ## In future, we will support > 2-class classification, but ignore for now
  if (is.classification) {
    if (learning.type == '2-class') {
      labels <- unique(y)
      illegal <- setdiff(c(-1, 1), labels)
      if (length(illegal) > 0) {
        stop("2-class labels can only be -1 and 1")
      }
    } else {
      stop("only 2-class classification supported for now")
    }
  } else if (learning.type == 'regression') {
    stop("regression not supported yet")
  } else {
    stop("illegal value for learning.type")
  }
  
  stopifnot(is.numeric(y))
  
  ptr <- .Call("create_labels", y, PACKAGE="shikken")
  new('Labels', sg.ptr=ptr)
}