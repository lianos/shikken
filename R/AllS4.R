setClass("ShikkenObject", contains="VIRTUAL",
         representation=representation(cache="environment"))

setMethod("initialize", "ShikkenObject",
function(.Object, ..., cache=new.env()) {
  callNextMethod(.Object, cache=cache, ...)
})

setClass("Labels", contains="ShikkenObject",
         representation=representation(
           y='numeric'),
         prototype=prototype(
           y=numeriic()))

setClass("ClassLabels", contains="Labels",
         representation=representation(
           factor.map='numeric'),
         prototype=prototype(
           factor.map=numeric()))

setClass("OneClassLabels", contains="ClassLabels")
setValidity("OneClassLabels", function(object) {
  errs <- character()
  if (length(object@y) == 0) {
    errs <- '0 length Labels'
  } else {
    if (any(object@y != object@y[1L])) {
      errs <- "Multiple labeles in OneClassLabel"
    }
  }

  if (length(errs)) errs else TRUE
})

setClass("TwoClassLabels", contains="ClassLabels")
setValidity("TwoClassLabels", function(object) {
  errs <- character()
  if (length(object@y) == 0) {
    errs <- '0 length Labels'
  } else {
    u.labels <- unique(object@y)
    n <- length(u.labels)
    if (n != 2L) {
      errs <- sprintf("Illegal number of labels (%d) for TwoClassLabel", n)
    }
    if (!all(u.labels %in% c(-1, 1))) {
      errs <- c("Only -1,1 allowd in TwoClassLabels", errs)
    }
  }

  if (length(errs)) errs else TRUE
})

setClass("MultiClassLabels", contains="ClassLabels")
setValidity("TwoClassLabels", function(object) {
  errs <- character()
  if (length(object@y) == 0) {
    errs <- '0 length Labels'
  } else {
    u.labels <- unique(object@y)
    n <- length(u.labels)
    if (n < 2L) {
      errs <- sprintf("Illegal number of labels (%d) for MultClassLabel", n)
    }
    if (!all(u.labels %in% seq_along(u.labels) - 1)) {
      errs <- c("MultiClassLabels start from 0 and must be whole numbers", errs)
    }
  }

  if (length(errs)) errs else TRUE
})

setClass("Machine", contains="ShikkenObject",
         representation=representation(
           type='character',
           params='list'),
         prototype=prototype(
           type=character(),
           params=list()))

setClass("KernelMachine", contains="Machine",
         representation=representation(
           preproc='list',
           normalize='list')
         prototype=prototype(
           preproc=list(),
           normalize=list()))

setClass("SVM", contains="KernelMachine",
         representation=representation(
           C="numeric",
           C.neg="numeric",
           nSV="integer",
           alpha="numeric",
           SVindex="integer"),
         prototype=prototype(
           C=1,
           C.neg=1,
           alpha=numeric(),
           nSV=integer(),
           SVindex=integer()))

setGeneric("weights", function(x, ...) standardGeneric("weights"))
setGeneric("weights<-", function(x, ..., value) standardGeneric("weights<-"))

setGeneric("normalizer", function(x, normalizer, ...) {
  standardGeneric("normalizer")
})

setGeneric("normalizer<-", function(x, ..., value) {
  standardGeneric("normalizer<-")
})

setGeneric("features", function(x, ...) standardGeneric("features"))
setGeneric("degree", function(x, ...) standardGeneric("degree"))
setGeneric("inhomogeneous", function(x, ...) standardGeneric("inhomogeneous"))

setGeneric("bias", function(x, ...) standardGeneric("bias"))

setGeneric("alphas", function(x, ...) standardGeneric("alphas"))
setGeneric("supportVectors", function(x, as.index=FALSE, ...) {
  standardGeneric("supportVectors")
})

setGeneric("objective", function(x, ...) standardGeneric("objective"))


###############################################################################
## Private

## Delegating to C
##' Returns the name of the C++ functions to use for different tasks
setGeneric("train.fn", function(x, ...) standardGeneric("train.fn"))
setGeneric("predict.fn", function(x, ...) standardGeneric("predict.fn"))
