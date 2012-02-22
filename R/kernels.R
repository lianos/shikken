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
                       do.clean=FALSE, ..., scaled=TRUE) {
  target <- toupper(match.arg(target))

  if (do.clean) {
    sgg('clean_features', 'TRAIN')
    sgg('clean_features', 'TEST')
    sgg('clean_kernel')
  }

  kernel <- matchKernelType(kernel)
  cache <- as.numeric(svm.params$cache)[1L]
  if (!isSingleDouble(cache)) {
    stop("Illegal value for cache")
  }

  k.info <- .kernel.map[[kernel]]
  if (is.null(k.info)) {
    stop("Could not find correct map for the normalized kernel name, ",
         "this should never happen.")
  }
  
  f.name <- paste('.init', k.info$class, sep="")
  initFunc <- tryCatch({
    getFunction(f.name)
  }, error=function(e) NULL)
  
  if (is.null(initFunc)) {
    stop("Kernel function (", f.name, ") for ", kernel, " ",
         "not implemented yet.")
  }
  
  result <- initFunc(x, k.info=k.info, target=target, cache=cache, ...)
  result$key <- kernel
  result
}

################################################################################
## String Kernels
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


.initSpectrumKernel <- function(x, k.info, target, cache=40, mkl=FALSE, ...) {
  x <- coerceStringInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  sgg('add_preproc', k.info$preproc)
  sgg(add.kernel, 'COMMSTRING', 'WORD', cache, params$use.sign,
      params$normalization)

  sgg('set_features', target, x, 'DNA')
  sgg('convert', target, 'STRING', 'CHAR', 'STRING', 'WORD',
     params$degree, params$degree - 1, params$gap, params$reverse)
  sgg('attach_preproc', target)
  
  params$x.dim <- c(nrow(x), params$length^4)
  params
}

.initWeightedDegreeKernel <- function(x, k.info, target, cache=40, mkl=FALSE,
                                      ...) {
  x <- coerceStringInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  sgg(add.kernel, 'WEIGHTEDDEGREE', 'CHAR', cache, params$degree)

  sgg('set_features', target, x, 'DNA')
  
  ## No sgg('convert', ...?)
  params$x.dim <- c(nrow(x), 0)
  params
}

.initWeightedDegreeKernelWithShifts <- function(x, k.info, target, cache=40,
                                                mkl=FALSE, ...) {

}


################################################################################Q
## Numeric kernels
coerceNumericInput <- function(x, k.info, ...) {
  if (is.character(x)) {
    if (length(x) == 1L && file.exists(x)) {
      stop("Support file based input, Numeric")
    }
  }

}

initNumericKernel <- function(x, kernel="linear", cache=40, ...) {

}

################################################################################
## Multiple Kernel Learning
