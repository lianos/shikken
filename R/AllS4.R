setClass("ShikkenObject", contains="VIRTUAL",
         representation=representation(cache="environment"))

setMethod("initialize", "ShikkenObject",
function(.Object, ..., cache=new.env()) {
  callNextMethod(.Object, cache=cache, ...)
})

setClass("Labels", contains="ShikkenObject",
         representation=representation(
           sg.ptr='externalptr',
           factor.map='numeric'))

setGeneric("threads", function(x, ...) standardGeneric("threads"))
setGeneric("params", function(x, ...) standardGeneric("params"))
################################################################################
## Preprocessors
## These objects act on the feature space massage/normalize
setClass("Preprocessor", contains="ShikkenObject",
         representation=representation(
           sg.ptr='externalptr'))

###############################################################################
## Features
setClass("Features", contains="ShikkenObject",
         representation=representation(
           sg.ptr="externalptr",
           n="integer",
           params="list" #, preprocessor
))

setClass("DotFeatures", contains="Features")
setClass("SimpleFeatures", contains="DotFeatures")

setClass("PolyFeatures", contains="DotFeatures")

setClass("SparsePolyFeatures", contains="DotFeatures")

setClass("SparseFeatures", contains="DotFeatures")

setClass("CombinedFeatures", contains="Features")

setClass("StringFeatures", contains="Features")
setClass("StringFileFeatures", contains="StringFeatures")

## -- methods

##' Features constructor
setGeneric("Features", signature=c("x", "type"), 
function(x, type, sparse=FALSE, ...) {
  standardGeneric("Features")
})

setGeneric("preprocessor", function(x, ...) standardGeneric("preprocessor"))
setGeneric("preprocessor<-", function(x, ..., value) {
  standardGeneric("preprocessor<-")
})

setGeneric("weights", function(x, ...) standardGeneric("weights"))
setGeneric("weights<-", function(x, ..., value) standardGeneric("weights<-"))

###############################################################################
## Kernel Normalizers
setClass("Normalizer", contains="ShikkenObject")

###############################################################################
## Kernels
setClass("Kernel", contains="ShikkenObject",
         representation=representation(
           sg.ptr="externalptr",
           params="list",
           features="Features",
           normalizer="Normalizer"))

## I am only mimicking the class hierarchy as it's laid out in the shogun
## codebase. I'm not sure we need the Kernel vs. DotKernel distinction at
## the R level.
setClass("CustomKernel", contains="Kernel")
setClass("CombinedKernel", contains="Kernel")


setClass("DotKernel", contains="Kernel")
setClass("GaussianKernel", contains="DotKernel")
setClass("LinearKernel", contains="DotKernel")
setClass("PolyKernel", contains="DotKernel",
         representation=representation(
           degree='integer',
           inhomogeneous='logical'),
         prototype=prototype(
           degree=2L,
           inhomogeneous=TRUE))

setClass("SigmoidKernel", contains="DotKernel")

setClass("StringKernel", contains="Kernel")
setClass("WeightedDegreeStringKernel", contains="StringKernel")

## -- methods
setGeneric("Kernel", function(x, ...) standardGeneric("Kernel"))

setGeneric("normalizer", function(x, normalizer, ...) {
  standardGeneric("normalizer")
})

setGeneric("normalizer<-", function(x, ..., value) {
  standardGeneric("normalizer<-")
})

setGeneric("features", function(x, ...) standardGeneric("features"))
setGeneric("degree", function(x, ...) standardGeneric("degree"))
setGeneric("inhomogeneous", function(x, ...) standardGeneric("inhomogeneous"))

###############################################################################
## Learning Machines
setClass("Machine", contains="ShikkenObject",
         representation=representation(
           sg.ptr="externalptr",
           num.threads="integer",
           type='character'))

setMethod("initialize", "Machine",
function(.Object, ..., num.threads=integer(), type=character()) {
  callNextMethod(.Object, num.threads=num.threads, type=type, ...)
})

setClass("LinearMachine", contains="Machine",
         representation=representation(
           bias="numeric",
           coef="numeric"))

setGeneric("bias", function(x, ...) standardGeneric("bias"))

setClass("KernelMachine", contains="Machine",
         representation=representation(
           kernel="Kernel"))#
# setMethod("initialize", "KernelMachine",
# function(.Object, ..., alpha=numeric(), sv.index=integer()) {
#   callNextMethod(.Object, alpha=alpha, sv.index=sv.index, ...)
# })

setGeneric("alphas", function(x, ...) standardGeneric("alphas"))
setGeneric("supportVectors", function(x, as.index=FALSE, ...) {
  standardGeneric("supportVectors")
})


setClass("DistanceMachine", contains="Machine") ## kmeans

## -- methods
setGeneric("train", function(x, ...) standardGeneric("train"))
setGeneric("trained", function(x, ...) standardGeneric("trained"))
setGeneric("trained<-", function(x, ...) standardGeneric("trained<-"))

setGeneric("threads<-", function(x, ..., value) standardGeneric("threads<-"))

setClass("SVM", contains="KernelMachine",
         representation=representation(
           labels="Labels",
           engine="character"))
setMethod("initialize", "SVM",
function(.Object, ..., engine=character()) {
  callNextMethod(.Object, engine=engine, ...)
})

setGeneric("objective", function(x, ...) standardGeneric("objective"))


setGeneric("kernel", function(x, ...) standardGeneric("kernel"))
setGeneric("kernel<-", function(x, ..., value) standardGeneric("kernel<-"))


setClass("KNN", contains="DistanceMachine",
         representation=representation(
           features="Features",
           labels="Labels"
           ))

###############################################################################
## Private

## Delegating to C
##' Returns the name of the C++ functions to use for different tasks
setGeneric("train.fn", function(x, ...) standardGeneric("train.fn"))
setGeneric("predict.fn", function(x, ...) standardGeneric("predict.fn"))