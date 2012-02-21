setClass("ShikkenObject", contains="VIRTUAL",
         representation=representation(cache="environment"))

setMethod("initialize", "ShikkenObject",
function(.Object, ..., cache=new.env()) {
  callNextMethod(.Object, cache=cache, ...)
})


##' Stores labels as numerics appropriate for Shogun.
##'
##' @export
##' @slot y A \code{numeric} vector of labels
setClass("Labels", contains="ShikkenObject",
         representation=representation(
           y='numeric'),
         prototype=prototype(
           y=numeric()))
setValidity("Labels", function(object) {
  errs <- c()
  if (!is.real(object@y)) {
    errs <- "only `real` types supported as labels"
  }
  if (length(errs)) errs else TRUE
})
##' Stores class labels, if a factor is used for classification
##'
##' @extends Class \code{Labels}.
##' @export
##'
##' @slot factor.map A named character vector that holds the labels
##' for the numeric stored in \code{@y}. The names are the character version
##' of the labels in \code{@y}, and the values are the labels themselves.
setClass("ClassLabels", contains="Labels",
         representation=representation(
           factor.map='numeric'),
         prototype=prototype(
           factor.map=numeric()))

##' Stores the class labels for a one-class classification problem
##'
##' Attempting to pass in a numeric with more than one value will result in
##' error.
##'
##' @extends Class \code{ClassLabels}
##' @export
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

##' Stores class labesl for two-class classification problem
##'
##' Passing in a vector of labels with \code{length(unique()) != 2}
##' will result in error
##'
##' @extends Class \code{ClassLabels}
##' @export
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

##' Stores class labesl for multi-class classification problem
##'
##' Passing in a vector of labels with \code{length(unique()) < 2}
##' will result in error.
##'
##' @extends Class \code{ClassLabels}
##' @export
setClass("MultiClassLabels", contains="ClassLabels")
setValidity("MultiClassLabels", function(object) {
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

##' Root class for a learning machine
##'
##' @slot type Learning scenario: regression, 1-class, 2-class, multi-class
##' @slot params A list of parameter used to configure the machine.
setClass("Machine", contains="ShikkenObject",
         representation=representation(
           type='character',
           params='list'),
         prototype=prototype(
           type=character(),
           params=list()))

##' A kernel-based learning machine
##'
##' @slot preproc List of preprocessor commands used to wire up the features
##' for the kernel(s) during training.
##' @slot normalize List of normalization commands used on the kernel(s) during
##' @slot kparams List of other kernel parameters during training.
setClass("KernelMachine", contains="Machine",
         representation=representation(
           preproc='list',
           normalize='list',
           kparams='list'),
         prototype=prototype(
           preproc=list(),
           normalize=list(),
           kparams=list()))

##' Support vector machine container
##'
##' @slot engine The solver used.
##' @slot C The value of the C parameter for positive class
##' @slot C.neg The value of the C parameter for negative class (2-class)
##' (classification only)
##' @slot nSV The number of support vectors
##' @slot alpha The weight over the support vectors
##' @slot SVindex The index of the support vectors from the input data
setClass("SupportVectorMachine", contains="KernelMachine",
         representation=representation(
           engine="character",
           C="numeric",
           C.neg="numeric",
           nSV="integer",
           alpha="numeric",
           SVindex="integer"),
         prototype=prototype(
           engine=character(),
           C=1,
           C.neg=1,
           alpha=numeric(),
           nSV=integer(),
           SVindex=integer()))

##' Extract weights (aka "beta"s to stats folk) from learning machine.
setGeneric("weights", function(x, ...) standardGeneric("weights"))

setGeneric("weights<-", function(x, ..., value) standardGeneric("weights<-"))

## setGeneric("normalizer", function(x, normalizer, ...) {
##   standardGeneric("normalizer")
## })

## setGeneric("normalizer<-", function(x, ..., value) {
##   standardGeneric("normalizer<-")
## })

## setGeneric("features", function(x, ...) standardGeneric("features"))
## setGeneric("degree", function(x, ...) standardGeneric("degree"))
## setGeneric("inhomogeneous", function(x, ...) standardGeneric("inhomogeneous"))

##' Extract the bias term from the learning machine
setGeneric("bias", function(x, ...) standardGeneric("bias"))

##' Extracts the alphas from SVM
setGeneric("alphas", function(x, ...) standardGeneric("alphas"))

##' Extracts the supportVectors from SVM
setGeneric("supportVectors", function(x, as.index=FALSE, ...) {
  standardGeneric("supportVectors")
})

##' Extract the objective
setGeneric("objective", function(x, ...) standardGeneric("objective"))


###############################################################################
## Private

## Delegating to C
##' Returns the name of the C++ functions to use for different tasks
## setGeneric("train.fn", function(x, ...) standardGeneric("train.fn"))
## setGeneric("predict.fn", function(x, ...) standardGeneric("predict.fn"))
