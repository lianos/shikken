setClass("ShikkenObject", contains="VIRTUAL")

setClass("Labels", contains="ShikkenObject",
         representation=representation(
           sg.ptr='externalptr'))

###############################################################################
## Features
setClass("Features", contains="ShikkenObject",
         representation=representation(
           sg.ptr="externalptr"))
setClass("DotFeatures", contains="Features")
setClass("SimpleFeatures", contains="DotFeatures")

setClass("PolyFeatures", contains="DotFeatures")
setClass("SparsePolyFeatures", contains="DotFeatures")

setClass("SparseFeatures", contains="DotFeatures")

setClass("CombinedFeatures", contains="Features")

setClass("StringFeatures", contains="Features")
setClass("StringFileFeatures", contains="StringFeatures")


###############################################################################
## Kernels
setClass("Kernel", contains="ShikkenObject",
         representation=representation(
           sg.ptr="externalptr",
           params="list",
           features="Features"))

## I am only mimicking the class hierarchy as it's laid out in the shogun
## codebase. I'm not sure we need the Kernel vs. DotKernel distinction at
## the R level.
setClass("CustomKernel", contains="Kernel")
setClass("StringKernel", contains="Kernel")
setClass("CombinedKernel", contains="Kernel")


setClass("DotKernel", contains="Kernel")
setClass("GaussianKernel", contains="DotKernel")
setClass("LinearKernel", contains="DotKernel")
setClass("PolyKernel", contains="DotKernel")
setClass("SigmoidKernel", contains="DotKernel")

setGeneric("normalizer", function(x, normalizer, ...) {
  standardGeneric("normalizer")
})

setGeneric("normalizer<-", function(x, ..., value) {
  standardGeneric("normalizer<-")
})

setGeneric("weights", function(x, ...) standardGeneric("weights"))
setGeneric("weights<-", function(x, ..., value) standardGeneric("weights<-"))

###############################################################################
## Kernel Normalizers
setClass("Normalizer", contains="ShikkenObject")

###############################################################################
## Learning Machines
setClass("LearningMachine", contains="ShikkenObject")
setClass("KernelMachine", contains="LearningMachine")
setClass("DistanceMachine", contains="LearningMachine") ## kmeans

setClass("SVM", contains="KernelMachine",
         representation=representation(
           sg.ptr="externalptr",
           kernel="Kernel",
           labels="Labels",
           type="character",
           engine="character",
           sv="integer",
           alpha="numeric"))

setGeneric("kernel", function(x, ...) standardGeneric("kernel"))
setGeneric("kernel<-", function(x, ..., value) standardGeneric("kernel<-"))
