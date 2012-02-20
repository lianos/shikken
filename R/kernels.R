supportedKernels <- function() {
 ## c('gaussian', 'linear', 'polynomial', 'sigmoid', 'weighted-degree-string', 'custom')
 ## c('gaussian', 'linear', 'sigmoid', 'weighted-degree-string')
  names(.kernel.map)
}

matchKernelType <- function(kernel) {
  match.arg(make.names(kernel), supportedKernels())
}

initStringKernel <- function(x, kernel="spectrum", cache=40, ...) {
  if (inherits(x, 'XStringSet')) {
    x <- as.matrix(as.character(x))
  }
  if (is.character(x)) {
    x <- as.matrix(x)
  }

  kernel <- matchKernelType(kernel)
  initFunc <- .kernel.map[[kernel]]$class
  initFunc <- getFunction(paste('init', initFunc, sep=""))
  initFunc(x, cache=cache, ...)
}

initSpectrumKernel <- function(x, cache=40, ...) {
  stopifnot(is.matrix(x) && is.character(x[1L]))
  kmap <- .kernel.map$spectrum
  params <- extractParams(..., .default=kmap$params)
  sg('add_preproc', kmap$preproc)
  sg('set_kernel', 'COMMSTRING', 'WORD', cache, params$use.sign,
     params$normalization)

  sg('set_features', 'TRAIN', x, 'DNA')
  sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD',
     params$length, params$length - 1, params$gap, params$reverse)
  sg('attach_preproc', 'TRAIN')
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
