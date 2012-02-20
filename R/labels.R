guessLearningTypeFromLabels <- function(labels, nlevels=NULL) {
  if (inherits(labels, "Labels")) {
    ltype <- switch(class(labels),
                    OneClassLabels="1-class",
                    TwoClassLabels="2-class",
                    MultiClassLabels="mult-class",
                    "regression")
    return(ltype)
  }
  
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


## TODO: Test memory allocation using Labels -- they're simple
# y <- lapply(1:10000, function(i) {
#   Labels(sample(c(-1,1), 2000, replace=TRUE))
# })
## rm()
## TODO: Add support for num_classes -- in this scenario, labels are
##       0 based, eg. 0, 1, 2, ..., C

Labels <- function(y, learning.type=NULL, factor.map=NULL, ...) {
  if (inherits(y, "Labels")) {
    return(y)
  }
  ## There are a lot of innefficiencies here -- `unique` is called many
  ## times on a (potential) factor to get the number of levels, to create
  ## the factor.map, etc. This could use some optimization, but it all this
  ## takes less than a second to run for 100k labels, so ... I'm not inclined
  ## to do so.
  learning.type <- matchLearningType(y, learning.type)
  is.classification <- length(grep('class', learning.type)) > 0L

  if (is.classification) {
    ## This part handles mult-class classifiation fine.
    if (is.factor(y)) {
      if (is.null(factor.map)) {
        y <- .createFactorMap(y, learning.type=learning.type)
        xref <- match(unique(y), y)
        factor.map <- y[xref]
      }
    } else {
      factor.map <- numeric()
    }
  }

  ## In future, we will support > 2-class classification, but ignore for now
  if (is.classification) {
    if (learning.type == '2-class') {
      is.illegal <- length(setdiff(c(-1, 1), unique(y))) > 0
      if (is.illegal) {
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
  new('Labels', sg.ptr=ptr, factor.map=factor.map)
}

.createFactorMap <- function(y, learning.type, nlevels=length(unique(y))) {
  ## This handles multi-class classification just fine.
  stopifnot(is.factor(y))
  yn <- as.numeric(y)
  names(yn) <- levels(y)[yn]
  if (learning.type == '2-class') {
    stopifnot(nlevels == 2)
    yn[yn == 2] <- -1
  } else if (learning.type == 'multi-class'){
    ## mutli-class, labels start at 0, 1, ..., C
    yn <- yn - 1L
  }
  yn
}


setMethod("length", "Labels", function(x) {
  length(x@labels)
})

setAs("Labels", "numeric", function(from) {
  x@labels
})

setAs("Labels", "vector", function(from) {
  x@labels
})

setAs("ClassLabels", "factor", function(from) {
  if (length(from@factor.map) == 0) {
    stop("No factor map for these labels")
  }
  out <- as(from, "numeric")
  chars <- names(from@factor.map)[match(from, from@factor.map)]
  as.factor(chars)
})

setAs("ClassLabels", "vector", function(from) {
  as(from, "numeric")
})

setMethod("as.numeric", c(x="Labels"), function(x) as(x, 'numeric'))
setMethod("as.vector", c(x="Labels"), function(x) as(x, 'vector'))
setMethod("as.integer", c(x="Labels"), function(x) {
  as.integer(as(x, 'numeric'))
})

setMethod("as.factor", c(x="ClassLabels"), function(x) as(x, 'factor'))
