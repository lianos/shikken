guessMachineTypeFromLabels <- function(labels) {
  if (inherits(labels, "Labels")) {
    machine.type <- switch(class(labels),
                           OneClassLabels="1-class",
                           TwoClassLabels="2-class",
                           MultiClassLabels="mult-class",
                           Labels="regression",
                           stop("Unknown Label class type"))
  } else {
    nlevels <- length(unique(labels))
    if (nlevels == 0) {
      stop("At least one level is required in your labels/factor.")
    } else if (nlevels == 1) {
      machine.type <- '1-class'
    } else if (nlevels == 2) {
      machine.type <- '2-class'
    } else {
      if (is.factor(labels)) {
        machine.type <- 'multi-class'
      } else {
        machine.type <- 'regression'
      }
    }
  }

  match.arg(machine.type, supportedMachineTypes())
}


## TODO: Test memory allocation using Labels -- they're simple
# y <- lapply(1:10000, function(i) {
#   Labels(sample(c(-1,1), 2000, replace=TRUE))
# })
## rm()
## TODO: Add support for num_classes -- in this scenario, labels are
##       0 based, eg. 0, 1, 2, ..., C
Labels <- function(y, machine.type=NULL, ...) {
  if (inherits(y, "Labels")) {
    return(y)
  }
  ## There are a lot of innefficiencies here -- `unique` is called many
  ## times on a (potential) factor to get the number of levels, to create
  ## the factor.map, etc. This could use some optimization, but it all this
  ## takes less than a second to run for 100k labels, so ... I'm not inclined
  ## to do so.
  m.type <- guessMachineTypeFromLabels(y)
  if (is.character(machine.type) && machine.type != m.type) {
    stop("Requested machine.type and label types do not gel")
  }

  machine.type <- m.type
  factor.map <- double()

  if (isClassificationMachine(machine.type)) {
    ## This part handles mult-class classifiation fine.
    if (is.factor(y)) {
      label.map <- .process.label.map(y, learning.type=machine.type)
      y <- label.map$y
      factor.map <- label.map$label.map
    } else {
      y <- unname(as.double(y))
      factor.map <- double()
    }

    clazz <- switch(machine.type,
                    "1-class"="OneClassLabels",
                    "2-class"="TwoClassLabels",
                    "multi-class"="MultiClassLabels",
                    "regression"="Labels",
                    stop("Tripped on unknown machine type during the 0-hour"))

    ans <- new(clazz, y=as.double(unname(y)), factor.map=factor.map)
  } else if (isRegressionMachine(machine.type)) {
    y <- unname(as.double(y))
    ans <- new("Labels", y=as.double(y))
  } else {
    stop("Unsupported learning machine")
  }

  validObject(ans)
  ans
}

setAs("ClassLabels", "factor", function(from) {
  if (length(from@factor.map) == 0L) {
    stop("Can't convert ClassLabels to factor w/o factor.map")
  }
  xref <- match(from@y, from@factor.map)
  factor(names(from@factor.map)[xref], levels=names(from@factor.map))
})


##' Returns a numeric vector of the labels found in factor y.
##'
##' The names are the labels from the factor.
.process.label.map <- function(y, learning.type) {
  ## This handles multi-class classification just fine.
  stopifnot(is.factor(y))
  unique.labels <- unique(y)
  nlevels <- length(unique.labels)
  xref.labels <- match(unique.labels, y)
  yd <- as.double(y)

  if (learning.type == '2-class') {
    stopifnot(nlevels == 2)
    yd[yd == 2] <- -1
  } else if (learning.type == 'multi-class'){
    ## mutli-class, labels start at 0, 1, ..., C
    stopifnot(nlevels > 2)
    yd <- yd - 1
  }

  factor.map <- double(length(xref.labels))
  for (i in seq(nlevels)) {
    factor.map[i] <- yd[xref.labels[i]]
  }
  names(factor.map) <- unique.labels

  list(y=unname(yd), label.map=factor.map)
}


setMethod("length", "Labels", function(x) {
  length(x@y)
})

setAs("Labels", "numeric", function(from) {
  x@y
})

setAs("Labels", "vector", function(from) {
  x@y
})

setAs("ClassLabels", "factor", function(from) {
  if (length(from@factor.map) == 0) {
    stop("No factor map for these labels")
  }
  out <- as(kernfrom, "numeric")
  factor(factor.map[as.character(out)])
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
