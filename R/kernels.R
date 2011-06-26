supportedKernels <- function() {
  c('gaussian', 'linear', 'polynomial', 'sigmoid', 'string', 'custom')
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

setMethod("Kernel", c(x="matrix"),
function(x, kernel='linear', params='automatic', scaled=TRUE, subset,
         na.action=na.omit, sparse=FALSE, ...) {
  kernel <- match.arg(kernel, supportedKernels())
  if (kernel %in% c('string', 'custom')) {
    stop(kernel, " not supported yet")
  }
  clazz <- paste(toupper(substring(kernel, 1, 1)),
                 tolower(substring(kernel, 2)), "Kernel", sep="")
  c.fn <- paste('create_kernel', kernel, sep='_')
  features <- createFeatures(x, sparse=sparse, scaled=scaled, ...)

  params <- list()

  if (kernel == 'gaussian') {
    kptr <- .Call(c.fn, features, width, cache.size, PACKAGE="shikken")
  } else if (kernel == 'linear') {
    kptr <- .Call(c.fn, features, PACKAGE="shikken")
  } else if (kernel == 'polynomial') {
    kptr <- .Call(c.fn, degree, inhomogeneous, cache.size, PACKAGE="shikken")
  } else if (kernel == 'sigmoid') {
    kptr <- .Call(c.fn, gamma, coef0, cache.size, PACKAGE="shikken")
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
