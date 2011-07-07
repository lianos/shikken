setMethod("length", "Features", function(x) {
  ## .Call("features_length", x@sg.ptr, PACKAGE="shikken")
  x@n
})

supportedFeatures <- function() {
  names(.feature.map)
}

matchFeatureType <- function(ftype) {
  match.arg(ftype, supportedFeatures())
}

matchFeatureClassToType <- function(fclass) {
  fclean <- gsub("Sparse", "", fclass, ignore.case=TRUE)
  known.classes <- sapply(.feature.map, '[[', 'class')
  idx <- which(fclean ==  known.classes)
  if (length(idx) != 1L) {
    stop("Can't match feature class ", fclass, " to feature type")
  }
  names(.feature.map)[idx]
}

## Make a new features object for a given Kernel class
setMethod("Features", c(x="ANY", type="Kernel"),
function(x, type, sparse=FALSE, ...) {
  Features(x, features(type), sparse=sparse, ...)
})

##' Creates a Features object from \code{x} that's like \code{type}
setMethod("Features", c(x="ANY", type="Features"),
function(x, type, sparse=FALSE, ...) {
  ## TODO: Grab @params from incoming Features object and send to
  ##       Features ctor.
  ftype <- matchFeatureClassToType(class(type)[1])
  Features(x, ftype, sparse=sparse, ...)
})

## Type must be a valid feature.type -- not a kernel name. To generate a feature
## object for a given kernel, use the Kernel(data, kernel) constructor and grab
## its features(), or call Features(x, KernelObject)
setMethod("Features", c(x="matrix", type="character"),
function(x, type='simple', sparse=FALSE, ...) {
  type <- matchFeatureType(type)
  Rfn <- getFunction(paste('createFeatures', type, sep="."))
  features <- Rfn(x, sparse=sparse, ...)
  features
})

###############################################################################
## Feature creation functions [not exported]
## ----------------------------------------------------------------------------
## Do not call these directly, let the Features ctor delegate to them via the
## x:type combo.
createFeatures.simple <- function(x, sparse=FALSE, ...) {
  stopifnot(isNumericMatrix(x))
  if (inherits(x, 'Matrix')) {
    stop("Support for Matrix class (for sparse matrixes) not implemented yet.")
  }
  
  n.obs <- nrow(x)
  n.dims <- ncol(x)
  x <- t(x)
  
  f.info <- .feature.map$simple
  if (sparse) {
    clazz <- f.info$class.sparse
    cfun <- f.info$cfun.sparse
  } else {
    clazz <- f.info$class
    cfun <- f.info$cfun
  }
  
  sg.ptr <- .Call(cfun, x, n.obs, n.dims, PACKAGE="shikken")
  new(clazz, sg.ptr=sg.ptr, n=n.obs)
}

createFeatures.polynomial <- function(x, sparse=FALSE, ...) {
  stopifnot(isNumericMatrix(x))
  
  n.obs <- nrow(x)
  n.dims <- ncol(x)
  x <- t(x)
  
  f.info <- .feature.map$polynomial
  params <- extractParams(x, ..., .defaults=f.info$params)
  
  if (sparse) {
    clazz <- f.info$class.sparse
    cfun <- f.info$cfun.sparse
    sg.ptr <- .Call(cfun, x, n.obs, n.dims, params$degree, params$normalize,
                    params$hash.bits, PACKAGE="shikken")
  } else {
    clazz <- f.info$class
    cfun <- f.info$cfun
    sg.ptr <- .Call(cfun, x, n.obs, n.dims, params$degree, params$normalize,
                    PACKAGE="shikken")
  }
  
  new(clazz, sg.ptr=sg.ptr, n=n.obs, degree=params$degree,
      normalize=params$normalize)
}

setMethod("degree", c(x="PolyFeatures"),
function(x, ...) {
  x@params$degree
})

createFeatures.string <- function(x, sparse=FALSE, ...) {
  
}

