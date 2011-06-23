setClass("Kernel", contains="ShikkenObject",
         representation=representation(
           kernel.sg.ptr="externalptr",
           params="list",
           features="Features"))

## I am only mimicking the class hierarchy as it's laid out in the shogun
## codebase. I'm not sure we need the Kernel vs. DotKernel distinction at
## the R level.
setClass("CustomKernel", contains="Kernel")
setClass("StringKernel", contains="Kernel")
setClass("CombinedKernel", contains="Kernel")


setClass("DotKernel", contains="Kernel")
setClass("GaussianKernel", contains="DotKernel")
setClass("LinearKernel", contains="DotKernel")
setClass("PolyKernel", contains="DotKernel")

supportedKernels <- function() {
  c('gaussian', 'normal', 'linear', 'polynomial', 'string', 'custom')
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
  
  features <- createFeatures(x, kernel, scaled=scaled, sparse=sparse, ...)
  kptr <- .Call("create_gaussian_kernel", features@features.sg.ptr,
                0.5, 10)
  skernel <- new("GaussianKernel",
                 kernel.sg.ptr=kptr,
                 params=list(),
                 features=features)
  skernel
})
