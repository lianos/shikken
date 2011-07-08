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
function(x, kernel='linear', scaled=TRUE, subset=NULL, na.action=na.omit,
         sparse=FALSE, cache.size=40, ...) {
  kernel <- matchKernelType(kernel)
  ftype <- matchKernelTypeToFeatureType(kernel)
  features <- Features(x, ftype, sparse=sparse, scaled=scaled, ...)
  Kernel(features, kernel, scaled=scaled, subset=subset, na.action=na.action,
         cache.size=cache.size, sparse=sparse, ...)
})

##' Creates the appropriate kernel out of the given Feature object
setMethod("Kernel", c(x="Features"),
function(x, kernel='linear', scaled=TRUE, subset=NULL, na.action=na.omit,
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
  
  ## Type checking done? Dispatch to non exported helper functions
  Rfn <- getFunction(paste('createKernel', kernel, sep="."))
  kernel <- Rfn(x, scaled=scaled, subset=subset, na.action=na.action,
                cache.size=cache.size, sparse=sparse, ...)
  kernel
})

createKernel.linear <- function(features, cache.size=40, ...) {
  kernel.info <- .kernel.map$linear
  sg.ptr <- .Call(kernel.info$cfun, features@sg.ptr, PACKAGE="shikken")
  new(kernel.info$class, sg.ptr=sg.ptr, params=list(), features=features)
}

createKernel.gaussian <- function(features, cache.size=40, ...) {
  kernel.info <- .kernel.map$gaussian
  params <- extractParams(data=NULL, ..., .defaults=kernel.info$param)
  sg.ptr <- .Call(kernel.info$cfun, features@sg.ptr, params$width, cache.size,
                  PACKAGE="shikken")
  new(kernel.info$class, sg.ptr=sg.ptr, params=params, features=features)
}

createKernel.sigmoid <- function(features, cache.size=40, ...) {
  kernel.info <- .kernel.map$sigmoid
  params <- extractParams(data=NULL, ..., .defaults=kernel.info$param)
  sg.ptr <- .Call(kernel.info$cfun, features@sg.ptr, params$gamma,
                  params$coef0, cache.size, PACKAGE="shikken")
  new(kernel.info$class, sg.ptr=sg.ptr, params=params, features=features)
}

createKernel.polynomial <- function(features, cache.size=40, ...) {
  kernel.info <- .kernel.map$polynomial
  params <- extractParams(data=NULL, ..., .defaults=kernel.info$param)
  sg.ptr <- .Call(kernel.info$cfun, features@sg.ptr, features@degree,
                  params$inhomogeneous, cache.size, PACKAGE="shikken")
  new(kernel.info$class, sg.ptr=sg.ptr, params=params, features=features)
}

createKernel.weighted.degree.string <- function(features, cache.size=40, ...) {
  kernel.info <- .kernel.map$weighted.degree.string
  stop("No string kernels implemented")
}

setMethod("features", c(x="Kernel"),
function(x, ...) {
  x@features
})

setMethod("params", c(x="Kernel"),
function(x, ...) {
  x@params
})

setMethod("degree", c(x="PolyKernel"),
function(x, ...) {
  x@params$degree
})

setMethod("inhomogeneous", c(x="PolyKernel"),
function(x, ...) {
  x@params$inhomogeneous
})
