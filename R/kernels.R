supportedKernels <- function() {
 ## c('gaussian', 'linear', 'polynomial', 'sigmoid', 'weighted-degree-string', 'custom')
 ## c('gaussian', 'linear', 'sigmoid', 'weighted-degree-string')
  names(.kernel.class.map)
}

matchKernelType <- function(kernel) {
  kernel <- match.arg(make.names(kernel), supportedKernels())
  stopifnot(kernel %in% names(.kernel.map))
  kernel
}

kernelClassName <- function(x, ...) {
  idx <- which(names(.kernel.class.map) == x)
  if (length(x) != 1) {
    stop("No class converion for kernel type: ", x)
  }
  .kernel.class.map[[idx]]$class
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

## Pass kernel parameters through ...
setMethod("Kernel", c(x="matrix"),
function(x, kernel='linear', scaled=TRUE, subset,
         na.action=na.omit, sparse=FALSE, cache.size=40, ...) {
  kernel <- matchKernelType(kernel)
  fclass <- kernelFeatureClass(kernel)
  features <- Features(x, fclass, sparse=sparse, scaled=scaled, ...)
  Kernel(features, kernel, scaled=scaled, subset=subset, na.action=na.action,
         cache.size=cache.size, sparse=sparse...)
})

setMethod("Kernel", c(x="Features"),
function(x, kernel='linear', scaled=TRUE, subset, na.action=na.omit,
         cache.size=40, sparse=sparse, ...) {
  ## TODO: Wire kernel and features info requirements (pairings) better!
  stopifnot(isSingleNumber(cache.size))
  kernel <- matchKernelType(kernel)
  kernel.info <- .kernel.map[[kernel]]
  
  features.class <- kernelFeatureClass(kernel) ## throws error if there's a problem
  if (features.class != gsub("Sparse", "", class(x)[1])) {
    stop("The class of the Features object [", class(x)[1], "] does not match",
         " the expectation mapping: ", features.class)
  }
  
  c.fn <- kernel.info$cfun
  params <- extractParams(x, ..., .defaults=kernel.info$params)
  
  browser()
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

