# setAs("Features", "Features", function(from) from)
setAs("matrix", "Features", function(from) {
  ## todo -- check sparsity?
  if (is.numeric(from)) {
    as.sparse <- (sum(from == 0) / length(from)) < .6
  } else {
    as.sparse <- FALSE
  }

  createFeatures(from, spase=as.sparse)
})

setMethod("length", "Features", function(x) {
  .Call("features_length", x@sg.ptr, PACKAGE="shikken")
})

setGeneric("createFeaturesFor", signature=c("x", "y"),
function(x, y, sparse=FALSE...) {
  standardGeneric("createFeaturesFor")
})

setMethod("createFeaturesFor", c(x="ANY", y="character"),
function(x, y, sparse, ...) {
  createFeatures(x, y, sparse=sparse, ...)
})

setMethod("createFeaturesFor", c(x="ANY", y="LearningMachine"),
function(x, y, sparse, ...) {
  ## 1. Figure out what type of features to kreate for hte kernel
  ## 2. Create them
  
})

createFeaturesFor <- function(x, y) {
  
}

##' Factory to create Shogun Feature Objects
##'
##' Shogun expects the features to be sent into the C interface in
##' column-major format, where each column represents one observation.
##'
createFeatures <- function(x, kernel='linear', sparse=FALSE, ...) {
  if (sparse) {
    density <- 'sparse'
    class.mod <- 'Sparse'
    stop("sparse features not yet supported")
  } else {
    density <- 'dense'
    class.mod <- 'Dense'
  }

  if (!is.numeric(x) || !is.matrix(x)) {
    stop("only numeric features supported now")
  }

  kernel <- matchKernelType(kernel)

  if (kernel == 'polynomial') {
    ## TODO
    n <- nrow(x)
  } else {
    ## libshogun expects to get the feature matrix with columns
    ## linear in memory, where each column is the feature vector for
    ## an example. This is the opposite of what "normal R" feature
    ## matrices usually are.
    fn <- paste('features_create_simple', density, sep="_")
    sg.ptr <- .Call(fn, t(x), nrow(x), ncol(x), PACKAGE="shikken")
    clazz <- if (sparse) 'SparseFeatures' else 'SimpleFeatures'
    n <- nrow(x)
  }

  new(clazz, sg.ptr=sg.ptr, n=n)
}
