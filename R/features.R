setClass("Features", contains="ShikkenObject",
         representation=representation(
           features.sg.ptr="externalptr",
           type='character'))

setClass("NumericDenseFeatures", contains="Features")
setClass("NumericSparseFeatures", contains="Features")
setClass("CombinedFeatures", contains="Features")
setClass("StringFeatures", contains="Features")

createFeatures <- function(x, kernel, sparse=FALSE, ...) {
  stopifnot(is.matrix(x))
  kernel <- match.arg(kernel, supportedKernels())
  if (sparse) {
    stop("Sparse features not implemented yet")
    # ext.ptr <- .Call("create_numeric_features_sparse", x, dim(x),
    #                  PACKAGE="shikken")
    # obj <- new('NumericSparseFeatures', )
  } else {
    ext.ptr <- .Call("create_numeric_features_dense", x, dim(x),
                     PACKAGE="shikken")
    obj <- new('NumericDenseFeatures',
               features.sg.ptr=ext.ptr,
               type='kernel')
  }
  
  #reg.finalizer(ext.ptr, disposeShogunPointer)
  obj
}
