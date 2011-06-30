setClass("ShikkenObject", contains="VIRTUAL")
setGeneric("threads", function(x, ...) standardGeneric("threads"))

setClass("Labels", contains="ShikkenObject",
         representation=representation(
           sg.ptr='externalptr',
           n='integer',
           factor.map='numeric'))

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
           n="integer"#, preprocessor="Preprocessor"))
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
setClass("PolyKernel", contains="DotKernel")
setClass("SigmoidKernel", contains="DotKernel")

setClass("StringKernel", contains="Kernel")
setClass("WeightedDegreeStringKernel", contains="StringKernel")

## -- methods

setGeneric("normalizer", function(x, normalizer, ...) {
  standardGeneric("normalizer")
})

setGeneric("normalizer<-", function(x, ..., value) {
  standardGeneric("normalizer<-")
})



###############################################################################
## Learning Machines
setClass("LearningMachine", contains="ShikkenObject",
         representation=representation(
           sg.ptr="externalptr",
           num.threads="integer",
           type='character',
           is.trained='logical'))

setClass("LinearMachine", contains="LearningMachine",
         representation=representation(
           bias="numeric",
           coef="numeric"))

setClass("KernelMachine", contains="LearningMachine",
         representation=representation(
           kernel="Kernel",
           alpha="numeric",
           sv.index="integer"))

setClass("DistanceMachine", contains="LearningMachine") ## kmeans

## -- methods

setGeneric("threads<-", function(x, ..., value) standardGeneric("threads<-"))

setClass("SVM", contains="KernelMachine",
         representation=representation(
           labels="Labels",
           engine="character",
           objective="numeric"))

setGeneric("kernel", function(x, ...) standardGeneric("kernel"))
setGeneric("kernel<-", function(x, ..., value) standardGeneric("kernel<-"))


setClass("KNN", contains="DistanceMachine",
         representation=representation(
           features="Features",
           labels="Labels"
           ))
