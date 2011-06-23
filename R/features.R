# setAs("Features", "Features", function(from) from)
setAs("matrix", "Features", function(from) {
  ## todo -- check sparsity?
  as.sparse <- (sum(from == 0) / length(from)) < .6
  createFeatures(from, spase=as.sparse)
})

createFeatures <- function(x, sparse=FALSE, ...) {
  if (sparse) {
    density <- 'sparse'
    class.mod <- 'Sparse'
  } else {
    density <- 'dense'
    class.mod <- 'Dense'
  }
  
  if (is.numeric(x)) {
    if (!is.matrix(x)) {
      stop("matrix is required for numeric features")
    }
    fn <- paste('create_numeric_features', density, sep="_")
    sg.ptr <- .Call(fn, x, dim(x), PACKAGE="shikken")
    type <- 'numeric'
    clazz <- paste('Numeric', class.mod, 'Features', sep='')
  } else {
    stop("feature creation for nun-numeric features not implemented.")
  }
  
  new(clazz, sg.ptr=sg.ptr, type=type)
}
