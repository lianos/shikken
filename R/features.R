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
  
  kernel <- match.arg(kernel, supportedKernels())
  
  if (kernel == 'polynomial') {
    ## TODO
  } else {
    ## libshogun expects to get the feature matrix with columns
    ## linear in memory, where each column is the feature vector for
    ## an example. This is the opposite of what "normal R" feature
    ## matrices usually are.
    fn <- paste('create_simple_features', density, sep="_")
    sg.ptr <- .Call(fn, t(x), nrow(x), ncol(x), PACKAGE="shikken")
    clazz <- if (sparse) 'SparseFeatures' else 'SimpleFeatures'
  }
  
  new(clazz, sg.ptr=sg.ptr)
}
