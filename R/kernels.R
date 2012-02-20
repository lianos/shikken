supportedKernels <- function() {
 ## c('gaussian', 'linear', 'polynomial', 'sigmoid', 'weighted-degree-string', 'custom')
 ## c('gaussian', 'linear', 'sigmoid', 'weighted-degree-string')
  names(.kernel.map)
}

matchKernelType <- function(kernel) {
  match.arg(make.names(kernel), supportedKernels())
}

matchKernelTypeToFeatureType <- function(kernel) {
  kernel <- matchKernelType(kernel)
  .kernel.map[[kernel]]$feature.type
}
 
kernelClassName <- function(x, ...) {
  kernel <- matchKernelType(x)
  .kernel.map[[kernel]]$class
}

## returns the name of the class of Features associated with this kernel
kernelFeatureClass <- function(kernel, sparse=FALSE, ...) {
  f.type <- matchKernelTypeToFeatureType(kernel)
  f.type <- matchFeatureType(f.type)
  f.info <- .feature.map[[f.type]]
  if (sparse) f.info$class.sparse else f.info$class
}

setGeneric("initKernel", signature=c("x"),
function(x, kernel, target=c('train', 'test'), preproc=NULL,
         normalizer=NULL, ... scaled=TRUE) {
  standardGeneric("initKernel")
})

initKernel <- function(x, kernel, target=c('train', 'test'),
                       preproc=NULL, normalizer=normalizer, ...,
                       scaled=TRUE) {
  
  if (is.character(x[1L])) {
    initStringKernel(x, kernel, target, preproc, normalizer, ..., scaled)
  } else (is.numeric(x[1L])) {
    initNumericKernel(x, kernel, target, preproc, normalizer, ..., scaled)
  }
  
  sg('clean_features', 'TRAIN')
  sg('clean_features', 'TEST')
  sg('clean_kernel')
  
}

initStringKernel <- function(x, kernel, target, preproc, normalizer, ...,
                             scaled) {

}

initNumericKernel <- function(x, kernel, target, preproc, normalizer, ...,
                              scaled) {

}
