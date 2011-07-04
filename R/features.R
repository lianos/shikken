##' Creates a Features object from \code{x} that's like \code{type}
setMethod("Features", c(x="ANY", type="Features"),
function(x, type, sparse=FALSE, ...) {
  clazz <- class(type)[1]
  if (missing(sparse)) {
    sparse <- grep('sparse', clazz, ignore.case=TRUE)
  }
  cclass <- gsub('sparse', '', clazz, ignore.case=TRUE)
  type <- switch(cclass, PolyFeatures='polynomial', 
                 SimpleFeatures='linear', Features='linear',
                 stop("Unknown features type: ", cclass))
  Features(x, type, sparse=sparse, ...)
})

setMethod("Features", c(x="matrix", type="character"),
function(x, type='linear', sparse=FALSE, ...) {
  if (!is.numeric(x)) {
    stop("only numeric features supported now")
  }
  
  ## Shogun uses the transpose of what we expect in R
  n.obs <- nrow(x)
  n.dims <- ncol(x)
  x <- t(x)
  
  type <- matchKernelType(type)
  
  if (sparse) {
    density <- 'sparse'
    class.mod <- 'Sparse'
    stop("sparse features not yet supported")
  } else {
    density <- 'dense'
    class.mod <- 'Dense'
  }
  
  if (type == 'polynomial') {
    fn <- 'features_create_polynomial'
    clazz <- if (sparse) 'SparsePolyFeatures' else 'PolyFeatures'
  } else {
    fn <- 'features_create_simple'
    clazz <- if (sparse) 'SparseFeatures' else 'SimpleFeatures'
  }
  
  if (length(density) == 1) {
    fn <- paste(fn, density, sep="_")
  }
  
  sg.ptr <- .Call(fn, x, n.obs, n.dims, PACKAGE="shikken")
  
  new(clazz, sg.ptr=sg.ptr, n=n.obs)
})

###############################################################################
## Don't use these
# setAs("Features", "Features", function(from) from)
# setAs("matrix", "Features", function(from) {
#   ## todo -- check sparsity?
#   if (is.numeric(from)) {
#     as.sparse <- (sum(from == 0) / length(from)) < .6
#   } else {
#     as.sparse <- FALSE
#   }
# 
#   createFeatures(from, sparse=as.sparse)
# })

setMethod("length", "Features", function(x) {
  ## .Call("features_length", x@sg.ptr, PACKAGE="shikken")
  x@n
})
