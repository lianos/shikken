setClass("Kernel",
         representation=representation(
           ptr="externalptr",
           ))

supportedKernels <- function() {
  c('guassian', 'normal', 'linear', 'polynomial')
}

createKernel <- function(kernel='gaussian', params='automatic', scaled=TRUE, ...) {
  if (is.character(kernel)) {
    kernel <- match.arg(kernel, supportedKernels)
  }
}

createGaussianKernel <- function(width=1, ...) {
  
}