supportedKernels <- function() {
  # c('gaussian', 'linear', 'polynomial', 'sigmoid', 'string', 'custom')
  c('gaussian', 'linear', 'sigmoid')
}

setGeneric("Kernel", function(x, ...) standardGeneric("Kernel"))

setMethod("Kernel", c(x="formula"),
function(x, data=NULL, scaled=TRUE, ...) {
  if (is.null(data) || missing(data)) {
    stop("data parameter is required for formula interface")
  }
  cl <- match.call()
  m <- match.call(expand.dots=FALSE)
  if (is.matrix(eval(m$data, parent.frame()))) {
    m$data <- as.data.frame(data)
  }
  m$... <- NULL
  m$formula <- m$x
  m$x <- NULL
  m$scaled <- NULL
  m[[1]] <- as.name("model.frame")
  m <- eval(m, parent.frame())
  Terms <- attr(m, "terms")
  attr(Terms, "intercept") <- 0    ## no intercept

  x <- model.matrix(Terms, m)

  if (length(scaled) == 1) {
    scaled <- rep(scaled, ncol(x))
  }
  if (any(scaled)) {
    remove <- unique(c(which(labels(Terms) %in% names(attr(x, "contrasts"))),
                       which(!scaled)))
    scaled <- !attr(x, "assign") %in% remove
  }
  Kernel(x, scaled=scaled, ...)
})

setMethod("Kernel", c(x="vector"),
function(x, ...) {
  Kernel(as.matrix(x), ...)
})


.extractParams <- function(kernel, params, ...) {
  kernel <- match.arg(kernel, supportedKernels())
  if (kernel == 'gaussian') {
    if (params == 'automatic') {
      params <- list(width=0.5)
    }
    stopifnot(isSingleNumber(params$width))
  } else if (kernel == 'linear') {
    params <- list()
  } else if (kernel == 'polynomial') {
    if (params == 'automatic') {
      params <- list(degree=2, inhomogeneous=TRUE)
    }
    stopifnot(isSingleNumber(params$degree))
    stopifnot(isTRUEorFALSE(params$inhomogeneous))
  } else if (kernel == 'sigmoid') {
    if (params == 'automatic') {
      params <- list(gamma=1, coef0=1)
    }
    stopifnot(isSingleNumber(params$gamma))
    stopifnot(isSingleNumber(params$coef0))
  }
  params
}

setMethod("Kernel", c(x="matrix"),
function(x, kernel='linear', params='automatic', scaled=TRUE, subset,
         na.action=na.omit, sparse=FALSE, cache.size=40, ...) {
  kernel <- match.arg(kernel, supportedKernels())
  if (kernel %in% c('string', 'custom')) {
    stop(kernel, " not supported yet")
  }
  stopifnot(isSingleNumber(cache.size))
  
  clazz <- paste(toupper(substring(kernel, 1, 1)),
                 tolower(substring(kernel, 2)), "Kernel", sep="")
  
  features <- createFeatures(x, kernel, sparse=sparse, scaled=scaled, ...)
  
  c.fn <- paste('create_kernel', kernel, sep='_')
  params <- .extractParams(kernel, params, ...)
  
  if (kernel == 'gaussian') {
    kptr <- .Call(c.fn, features@sg.ptr, params$width, cache.size,
                  PACKAGE="shikken")
  } else if (kernel == 'linear') {
    kptr <- .Call(c.fn, features@sg.ptr, PACKAGE="shikken")
  } else if (kernel == 'polynomial') {
    kptr <- .Call(c.fn, features@sg.ptr, params$degree,
                  params$inhomogeneous, cache.size,
                  PACKAGE="shikken")
  } else if (kernel == 'sigmoid') {
    kptr <- .Call(c.fn, features@sg.ptr, params$gamma, params$coef0,
                  cache.size, PACKAGE="shikken")
  } else if (kernel == 'string') {
    ## TODO
  } else if (kernel == 'custom') {
    ## TODO
  }

  skernel <- new(clazz, sg.ptr=kptr, params=params, features=features)
  skernel
})

setMethod("Kernel", c(x="Features"),
function(x, kernel='linear', params='automatic', scaled=TRUE, subset,
         na.action=na.omit, sparse=FALSE, ...) {

})

kernelClassName <- function(kernel) {
  kernel <- match.arg(kernel, supportedKernels())

  if (kernel == 'polynomial') {
    cname <- if (sparse) 'SparsePolyFeatures' else 'PolyFeatures'
  } else if (kernel == 'combined') {
    cname <- ''
  }
  if (kernel == 'string') {

  } else {
    cname <- if (sparse) 'SparseFeatures' else 'SimpleFeatures'
  }
}

validFeaturesForKernelType <- function(x, kernel) {

}

