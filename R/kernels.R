supportedKernels <- function() {
 ## c('gaussian', 'linear', 'polynomial', 'sigmoid', 'weighted-degree-string', 'custom')
 ## c('gaussian', 'linear', 'sigmoid', 'weighted-degree-string')
  names(.kernel.map)
}

matchKernelType <- function(kernel) {
  match.arg(make.names(kernel), supportedKernels())
}

matchKernelTarget <- function(target) {
  target <- match.arg(tolower(target), c('train', 'test'))
  toupper(target)
}

initKernel <- function(x, kernel, svm.params, target=c('train', 'test'),
                       preproc=NULL, normalizer=normalizer,
                       do.clean=TRUE, ..., scaled=TRUE) {
  if (do.clean) {
    sg('clean_features', 'TRAIN')
    sg('clean_features', 'TEST')
    sg('clean_kernel')
  }

  target <- match.arg(target)
  kernel <- matchKernelType(kernel)
  cache <- as.numeric(cache)[1L]
  if (!isSingleNumber(cache)) {
    stop("Illegal value for cache")
  }

  k.info <- .kernel.map[[kernel]]
  if (is.null(k.info)) {
    stop("Could not find correct map for the normalized kernel name, "
         "this should never happen.")
  }

  initFunc <- getFunction(paste('.init', k.info$class, sep=""))
  initFunc(x, k.info=k.info, cache=cache, ...)
}

coerceStringInput <- function(x, k.info, ...) {
  if (inherits(x, 'XStringSet')) {
    x <- as.character(x)
  }
  if (is.character(x)) {
    if (length(x) == 1L && file.exists(x)) {
      stop("TODO: Support file based input,character")
    } else {
      x <- as.matrix(x)
    }
  }
  if (!is.matrix(x) && !is.character(x[1L])) {
    stop("String Input is expected to be a character matrix")
  }
  if (ncol(x) != 1L) {
    stop("Character input must be a single column matrix")
  }
  x
}

coerceNumericInput <- function(x, k.info, ...) {
  if (is.character(x)) {
    if (length(x) == 1L && file.exists(x)) {
      stop("Support file based input, Numeric")
    }
  }

}

################################################################################
## String Kernels
.initSpectrumKernel <- function(x, k.info, svm.params, target, mkl=FALSE, ...) {
  x <- coerceStringInput(x, k.info, ...)
  params <- extractParams(..., .default=kmap$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  sg('add_preproc', kmap$preproc)
  sg(add.kernel, 'COMMSTRING', 'WORD', cache, params$use.sign,
     params$normalization)

  sg('set_features', target, x, 'DNA')
  sg('convert', target, 'STRING', 'CHAR', 'STRING', 'WORD',
     params$length, params$length - 1, params$gap, params$reverse)
  sg('attach_preproc', target)
}


################################################################################Q
## Numeric kernels
initNumericKernel <- function(x, kernel="linear", cache=40, ...) {

}

################################################################################
## Multiple Kernel Learning
