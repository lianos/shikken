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

  match(machine.type, supportedMachineTypes())
}


## TODO: Test memory allocation using Labels -- they're simple
# y <- lapply(1:10000, function(i) {
#   Labels(sample(c(-1,1), 2000, replace=TRUE))
# })
## rm()
## TODO: Add support for num_classes -- in this scenario, labels are
##       0 based, eg. 0, 1, 2, ..., C

Labels <- function(y, machine.type=NULL, factor.map=NULL, ...) {
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

  if (isClassificationMachine(machine.type)) {
    ## This part handles mult-class classifiation fine.
    if (is.factor(y)) {
      if (is.null(factor.map)) {
        labels <- .factors2labels(y, learning.type=learning.type)
        factor.map <- unique(names(labels))
        xref <- match(label.names, names(labels))
        names(factor.map) <- as.character(labels[xref])
      }
    } else {
      factor.map <- numeric()
    }

    clazz <- switch(machine.type,
                    "1-class"="OneClassLabels",
                    "2-class"="TwoClassLabels",
                    "multi-class"="MultiClassLabels")
    ans <- new(clazz, y=unname(y), factor.map=factor.map)
  } else {
    ans <- new("Labels", y=y)
  }

  validObject(ans)
  ans
}

.factors2labels <- function(y, learning.type, nlevels=length(unique(y))) {
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
  out <- as(from, "numeric")
  factor(factor.map[as.character(out))])
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
