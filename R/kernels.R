setClass("Kernel", contains="VIRTUAL",
         representation=representation(
           ptr="externalptr",
           params="list"))

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

supportedKernels <- function() {
  c('guassian', 'normal', 'linear', 'polynomial', 'string', 'custom')
}

createKernel <- function(kernel='linear', params='automatic', scaled=TRUE, ...) {
  if (is.character(kernel)) {
    kernel <- match.arg(kernel, supportedKernels)
  }
}

createGaussianKernel <- function(x, width=1, ...) {
  
}

createStringKernel <- function(x, ...) {
  if (is.character(x) && length(x) == 1) {
    ## This is a file
    create
  }
}