
guessLearningTypeFromLabels <- function(y, learning.type=NULL) {
  if (missing(y)) {
    stop("Insufficient parameters to guess machine type")
  }
  if (missing(learning.type) || is.null(learning.type)) {
    if (is.factor(y)) {
      # nlevels <- length(levels(y))
      nlevels <- length(unique(y))
      if (nlevels == 0) {
        stop("At least one level is required in your labels/factor.")
      } else if (nlevels == 1) {
        learning.type <- '1-class'
      } else if (nlevels == 2) {
        learning.type <- '2-class'
      } else {
        learning.type <- 'multi-class'
      }
    } else {
      learning.type <- 'regression'
    }
  }
  
  learning.type <- match.arg(learning.type, supportedMachineTypes())
  
  if (learning.type == 'classification') {
    learning.type <- '2-class'
  }
  
  learning.type
}

createLabels <- function(y, learning.type=NULL, ...) {
  learning.type <- guessLearningTypeFromLabels(y, learning.type)
  
  is.classification <- length(grep('class', learning.type)) > 0L
  
  ## In future, we will support > 2-class classification, but ignore for now
  if (learning.type == '2-class') {
    if (is.factor(y)) {
      labels <- levels(y)[unique(y)]
      y <- as.numeric(y)
      y[y == 2] <- -1
      attr(y, 'labels') <- labels
    }
  } else if (learning.type == 'regression') {
    labels <- character()
  }
  
  stopifnot(is.numeric(y))
  
  ptr <- .Call("create_labels", y, PACKAGE="shikken")
  new('Labels', sg.ptr=ptr, labels=labels)
}