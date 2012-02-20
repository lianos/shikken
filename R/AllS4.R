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
setClass("TwoClassLabels", contains="ClassLabels")
setClass("MultiClassLabels", contains="ClassLabels")

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