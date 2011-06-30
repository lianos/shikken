setMethod("length", "Labels", function(x) {
  .Call("label_length", x@sg.ptr, PACKAGE="shikken")
})

setAs("Labels", "numeric", function(from) {
  .Call("get_labels", from@sg.ptr, PACKAGE="shikken")
})

setAs("Labels", "vector", function(from) {
  out <- as(from, "numeric")
  if (length(from@factor.map) > 0) {
    chars <- names(from@factor.map)[match(from, from@factor.map)]
    out <- as.factor(chars)
  }
  out
})

guessLearningTypeFromLabels <- function(labels, nlevels=NULL) {
  if (is.null(nlevels)) {
    nlevels <- length(unique(labels))
  }

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

.createFactorMap <- function(y, learning.type, nlevels=length(unique(y))) {
  stopifnot(is.factor(y))
  yn <- as.numeric(y)
  names(yn) <- levels(y)[yn]
  if (learning.type == '2-class') {
    stopifnot(nlevels == 2)
    yn[yn == 2] <- -1
  }
  yn
}

createLabels <- function(y, learning.type=NULL, factor.map=NULL, ...) {
  learning.type <- matchLearningType(y, learning.type)
  is.classification <- length(grep('class', learning.type)) > 0L

  if (is.classification) {
    if (is.factor(y)) {
      if (is.null(factor.map)) {
        y <- .createFactorMap(y, learning.type=learning.type)
        xref <- match(c(1, -1), y)
        factor.map <- y[xref]
      }
    } else {
      factor.map <- numeric()
    }
  }

  ## In future, we will support > 2-class classification, but ignore for now
  if (is.classification) {
    if (learning.type == '2-class') {
      illegal <- setdiff(c(-1, 1), unique(y))
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
  stopifnot(is.numeric(factor.map))

  ptr <- .Call("labels_create", y, PACKAGE="shikken")
  new('Labels', sg.ptr=ptr, factor.map=factor.map, n=length(y))
}
