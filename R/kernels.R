.kernel.class.map <- list(
  gaussian=list(
    class='GaussianKernel',
    params=list(width=0.5)),
  linear=list(
    class='LinearKernel',
    params=list()),
  sigmoid=list(
    class='SigmoidKernel',
    params=list(gamma=1, coef0=1)),
  polynomial=list(
    class='PolyKernel',
    params=list(degree=2)),
  weighted.degree.string=list(
    class="WeightedDegreeStringKernel",
    params=list(weights=1, degree=2L, alphabet="DNA"))
)

supportedKernels <- function() {
 ## c('gaussian', 'linear', 'polynomial', 'sigmoid', 'weighted-degree-string', 'custom')
 ## c('gaussian', 'linear', 'sigmoid', 'weighted-degree-string')
  names(.kernel.class.map)
}

matchKernelType <- function(kernel) {
  match.arg(make.names(kernel), supportedKernels())
}

kernelClassName <- function(x, ...) {
  idx <- which(names(.kernel.class.map) == x)
  if (length(x) != 1) {
    stop("No class converion for kernel type: ", x)
  }
  .kernel.class.map[[idx]]$class
}

##' Sets the parameter for the given kernel.
##'
##' Default values are provided for each kernel parameter. The parameters returned
##' from this function are gauranteed to be of the correct type so they can be
##' confidently passed to the C routines
##'
##' @param kernel \code{character} The name of the kernel.
##' @param data The data matrix. This could be used to extract default values for
##' some kernel parameters, if we can get smart about engineering those.
##' @param ... parameter name=value pairs are searched in these variables that
##' will be used to override the paremeters of the same name for the kernel.
##'
##' @return A list of named parameter values.
.extractParams <- function(kernel, data, ...) {
  kernel <- matchKernelType(kernel)
  default.params <- .kernel.class.map[[kernel]]$params
  new.params <- default.params
  args <- list(...)

  for (name in names(default.params)) {
    def.param <- default.params[[name]]
    new.param <- args[[name]]
    if (is.null(new.param)) {
      new.params[[name]] <- def.param
    } else {
      ## Override default value
      if (class(def.param) != class(new.param)) {
        stop("Illegal type for ", kernel, ":", name, " ",
             class(new.param), " parameter.")
      }
      if (length(def.param) != length(new.param)) {
        stop("Illegal length for ", kernel, ":", name, " parameter ",
             "[", length(new.param))
      }
      new.params[[name]] <- new.param
    }
  }

  if (!all(names(new.params) %in% names(default.params))) {
    stop("Missing some paremeters for kernel ...")
  }

  new.params
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
  features <- createFeatures(x, kernel, sparse=sparse, scaled=scaled, ...)
  Kernel(features, kernel, scaled=scaled, subset=subset, na.action=na.action,
         cache.size=cache.size, sparse=sparse...)
})

setMethod("Kernel", c(x="Features"),
function(x, kernel='linear', scaled=TRUE, subset, na.action=na.omit,
         cache.size=40, sparse=sparse, ...) {
  kernel <- matchKernelType(kernel)
  stopifnot(isSingleNumber(cache.size))

  c.fn <- paste('create_kernel', gsub(".", "_", kernel, fixed=TRUE) , sep='_')
  params <- .extractParams(kernel, x, ...)
  clazz <- kernelClassName(kernel)

  if (kernel == 'gaussian') {
    kptr <- .Call(c.fn, x@sg.ptr, params$width, cache.size,
                  PACKAGE="shikken")
  } else if (kernel == 'linear') {
    kptr <- .Call(c.fn, x@sg.ptr, PACKAGE="shikken")
  } else if (kernel == 'polynomial') {
    kptr <- .Call(c.fn, x@sg.ptr, params$degree,
                  params$inhomogeneous, cache.size,
                  PACKAGE="shikken")
  } else if (kernel == 'sigmoid') {
    kptr <- .Call(c.fn, x@sg.ptr, params$gamma, params$coef0,
                  cache.size, PACKAGE="shikken")
  } else if (kernel == 'weighted.degree.string') {
    kptr <- .Call(c.fn, x@sg.ptr, params$weight, params$degree,
                  PACKAGE="shikken")
  } else if (kernel == 'custom') {
    ## TODO
  }

  skernel <- new(clazz, sg.ptr=kptr, params=params, features=x)
  skernel
})

