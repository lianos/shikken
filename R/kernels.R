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

initMklKernel <- function() {
  ## TODO: Use initMklKernel to dispatch to initKernel
}

initCombinedKernel <- function() {
  ## TODO: use initCombinedKernel to dispatch to initKernel
}

initKernel <- function(x, kernel, svm.params, target=c('train', 'test'),
                       cache=40, preproc=NULL, normalizer=normalizer,
                       is.mkl=FALSE, is.combined=FALSE, scaled=TRUE, ...) {
  target <- toupper(match.arg(target))
  
  cache <- as.numeric(ceiling(cache))
  if (!isSingleDouble(cache)) {
    stop("Illegal value for cache")
  }
  
  ## Are you passing in a kernel configuration?
  if (is.list(kernel)) {
    if (is.mkl) {
      stop("MKL not supported yet")
    }
    if (is.combined) {
      stop("Combined kernels not supported yet")
    }
    if (is.null(kernel$key)) {
      stop("Invalid kernel configuration -- key is missing")
    }
    kernel <- matchKernelType(kernel$key)
    k.info <- kernel
  } else if (is.character(kernel)) {
    kernel <- matchKernelType(kernel)
    k.info <- .kernel.map[[kernel]]
  }

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

  initFunc(x, k.info=k.info, target=target, cache=cache, ...)
}

################################################################################
## String Kernels
##
## From easysvm:
##
##   for the string kernels there exist specific optimizations that are only
##   effective when using a LinAdd SVM implementation (e.g. SVM-light or GPBT-SVM)
##     - 'wd', 'spec', 'cumspec', 'spec2', 'cumspec2'
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
  
  sgg('add_preproc', k.info$preproc$type)
  if (target == "TRAIN") {
    sgg(add.kernel, k.info$static, 'WORD', cache, params$use.sign,
        params$normalization)
  }
  
  sgg('set_features', target, x, k.info$alphabet)

  ## convert .... from_class, from_type, to_class, to_type
  sgg('convert', target,
      k.info$convert$from.class, k.info$convert$to.class,
      k.info$convert$to.class, k.info$convert$to.type,
      k.info$covert$degree, k.info$convert$from.degree - 1,
      k.info$convert$gap, k.info$convert$reverse)
  sgg('attach_preproc', target)

  k.info$params <- params
  k.info$x.dim <- c(nrow(x), params$length^4)
  k.info
}

.initWeightedSpectrumKernel <- function(x, k.info, target, cache=40, mkl=FALSE,
                                        ...) {
  x <- coerceStringInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  sgg('add_preproc', k.info$preproc$type)
  if (target == "TRAIN") {
    sgg(add.kernel, k.info$static, 'WORD', cache, params$use.sign,
        params$normalization)
  }
  
  sgg('set_features', target, x, k.info$alphabet)

  ## convert .... from_class, from_type, to_class, to_type
  sgg('convert', target,
      k.info$convert$from.class, k.info$convert$to.class,
      k.info$convert$to.class, k.info$convert$to.type,
      k.info$covert$degree, k.info$convert$from.degree - 1,
      k.info$convert$gap, k.info$convert$reverse)
  sgg('attach_preproc', target)

  k.info$params <- params
  k.info$x.dim <- c(nrow(x), params$length^4)
  k.info
}

.initWeightedDegreeKernel <- function(x, k.info, target, cache=40, mkl=FALSE,
                                      ...) {
  x <- coerceStringInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  if (target == "TRAIN") {
    sgg(add.kernel, k.info$static, 'CHAR', cache, params$degree,
        params$mismatch, params$normalization, params$step,
        params$block.computation)
  }

  sgg('set_features', target, x, 'DNA')

  ## From easysvm:
  ## kernel=WeightedDegreePositionStringKernel(feats_train, feats_train,
  ##                                           kparam['degree'])
  ## kernel.set_normalizer(AvgDiagKernelNormalizer(float(kparam['seqlength'])))
  ## kernel.set_shifts(kparam['shift'] * numpy.ones(kparam['seqlength'],
  ##                   dtype=numpy.int32))
  ## No sgg('convert', ...?)
  k.info$params <- params
  k.info$x.dim <- c(nrow(x), 0)
  k.info
}

.initWeightedDegreeKernelWithShifts <- function(x, k.info, target, cache=40,
                                                mkl=FALSE, ...) {
  x <- coerceStringInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  if (target == "TRAIN") {
    ## static call:
    ## create_weighteddegreepositionstring(
    ##   size, order, max_mismatch, length, center, step);
    ## 
    ## CGUIKernel::create_weighteddegreepositionstring
    ##   int32_t size, int32_t order, int32_t max_mismatch, int32_t length,
    ##   int32_t center, float64_t step
    ##   ...
    ##   float64_t* weights=get_weights(order, max_mismatch);
    sgg(add.kernel, k.info$static, 'CHAR', cache,
        as.integer(params$degree),
        as.integer(params$max.mismatch),
        as.integer(params$length), ## position shifts   (shift)
        as.integer(params$center), ## number of shifts  (shift_len)
        as.real(params$step))
  }

  sgg('set_features', target, x, 'DNA')

  k.info$params <- params
  k.info$x.dim <- c(nrow(x), 0)
  k.info
}


################################################################################Q
## Numeric kernels
coerceNumericInput <- function(x, k.info, ...) {
  if (is.character(x)) {
    if (length(x) == 1L && file.exists(x)) {
      stop("Support file based input, Numeric")
    }
  }
  if (!is.matrix(x)) {
    stop("Input should be a double matrix")
  }
  if (!is.double(x[1,1])) {
    warning("Coercing numeric input to real")
    storage.mode(x) <- 'double'
  }
  x
}

.initLinearKernel <- function(x, k.info, target, cache=40, mkl=FALSE, ...) {
  x <- coerceNumericInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  if (target == 'TRAIN') {
    sgg(add.kernel, k.info$static, 'REAL', cache, params$scale)
  }
  
  sgg('set_features', target, t(x))
  sgg('set_kernel_normalization', 'SQRTDIAG')

  k.info$params <- params
  k.info$x.dim <- rev(dim(x))
  k.info
}

.initPolyKernel <- function(x, k.info, target, cache=40, mkl=FALSE, ...) {
  x <- coerceNumericInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  if (target == "TRAIN") {
    sgg(add.kernel, k.info$static, 'REAL', cache,
        params$degree,
        params$inhomogeneous,
        params$normalization)
  }

  sgg('set_features', target, t(x))

  k.info$params <- params
  k.info$x.dim <- rev(dim(x))
  k.info
}

.initSigmoidKernel <- function(x, k.info, target, cache=40, mkl=FALSE, ...) {
  x <- coerceNumericInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  if (target == "TRAIN") {
    sgg(add.kernel, k.info$static, 'REAL', cache,
        params$gamma,
        params$coef0)
  }

  sgg('set_features', target, t(x))

  k.info$x.dim <- rev(dim(x))
  k.info$params <- params
  k.info
}

.initGaussianKernel <- function(x, k.info, target, cache=40, mkl=FALSE, ...) {
  x <- coerceNumericInput(x, k.info, ...)
  params <- extractParams(..., .defaults=k.info$params)
  add.kernel <- if (mkl) 'add_kernel' else 'set_kernel'
  
  if (target == "TRAIN") {
    sgg(add.kernel, k.info$static, 'REAL', cache, params$width)
  }
  
  sgg('set_features', target, t(x))

  k.info$x.dim <- rev(dim(x))
  k.info$params <- params
  k.info
}

################################################################################
## Multiple Kernel Learning
