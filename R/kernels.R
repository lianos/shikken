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

setGeneric("Kernel", function(x, ...) standardGeneric("Kernel"))

setMethod("Kernel", c(x="formula"),
function(x, data=NULL, kernel='linear', scaled=TRUE, ...) {
  if (is.null(data) || missing(data)) {
    stop("data parameter is required for formula interface")
  }
  kernel <- matchKernelType(kernel)
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
  Kernel(x, kernel=kernel, scaled=scaled, ...)
})

setMethod("Kernel", c(x="vector"),
function(x, ...) {
  Kernel(as.matrix(x), ...)
})

## Pass kernel parameters through ...
setMethod("Kernel", c(x="matrix"),
function(x, kernel='linear', scaled=TRUE, subset, na.action=na.omit,
         sparse=FALSE, cache.size=40, ...) {
  kernel <- matchKernelType(kernel)
  ftype <- matchKernelTypeToFeatureType(kernel)
  features <- Features(x, ftype, sparse=sparse, scaled=scaled, ...)
  Kernel(features, kernel, scaled=scaled, subset=subset, na.action=na.action,
         cache.size=cache.size, sparse=sparse...)
})

##' Creates the appropriate kernel out of the given Feature object
setMethod("Kernel", c(x="Features"),
function(x, kernel='linear', scaled=TRUE, subset, na.action=na.omit,
         cache.size=40, sparse=sparse, ...) {
  ## TODO: Wire kernel and features info requirements (pairings) better!
  stopifnot(isSingleNumber(cache.size))
  kernel <- matchKernelType(kernel)
  kernel.info <- .kernel.map[[kernel]]
  
  expected.class <- kernelFeatureClass(kernel) ## throws error if there's a problem
  if (expected.class != class(x)) {
    stop("The class of the Features object [", class(x)[1], "] does not match",
         " the expectation mapping: ", features.class)
  }
  
  c.fn <- kernel.info$cfun
  params <- extractParams(x, ..., .defaults=kernel.info$params)
  
  if (kernel == 'gaussian') {
    kptr <- .Call(c.fn, x@sg.ptr, params$width, cache.size,
                  PACKAGE="shikken")
  } else if (kernel == 'linear') {
    kptr <- .Call(c.fn, x@sg.ptr, PACKAGE="shikken")
  } else if (kernel == 'polynomial') {
    kptr <- .Call(c.fn, x@sg.ptr, params$degree, params$inhomogeneous,
                  cache.size, PACKAGE="shikken")
  } else if (kernel == 'sigmoid') {
    kptr <- .Call(c.fn, x@sg.ptr, params$gamma, params$coef0, cache.size,
                  PACKAGE="shikken")
  } else if (kernel == 'weighted.degree.string') {
    kptr <- .Call(c.fn, x@sg.ptr, params$weight, params$degree,
                  PACKAGE="shikken")
  } else if (kernel == 'custom') {
    ## TODO
  }

  skernel <- new(kernel.info$class, sg.ptr=kptr, params=params, features=x)
  skernel
})

setMethod("features", c(x="Kernel"),
function(x, ...) {
  x@features
})

setMethod("degree", c(x="PolyKernel"),
function(x, ...) {
  x@params$degree
})

setMethod("inhomogeneous", c(x="PolyKernel"),
function(x, ...) {
  x@params$inhomogeneous
})
