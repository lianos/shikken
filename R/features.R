kernelFeatureClass <- function(kernel) {
  kernel <- matchKernelType(kernel)
  fclass <- .kernel.map[[kernel]]$data$class
  if (is.null(fclass)) {
    stop("No kernel <-> feature map for ", kernel, " kernel.")
  }
}

kernelFeatureType <- function(kernel) {
  fclass <- kernelFeatureClass(kernel)
  map <- names(.data.map)
  names(map) <- sapply(.data.map, '[[', class)
  type <- map[fclass]
  if (is.na(type)) {
    stop("Can't match kernel [", kernel, "] to data names() of .data.map")
  }
  type
}

setMethod("Features", c(x="ANY", type="Kernel"),
function(x, type, sparse=FALSE, ...) {
  Features(x, type@features, sparse=sparse, ...)
})

###############################################################################
## TODO: Figure out if `type` is
##   (i)  a kernel name,
##  (ii)  a names() of .data.map; or
##  (iii) name of a Feature class
## 
## For the following two functions
##############################################################################

##' Creates a Features object from \code{x} that's like \code{type}
setMethod("Features", c(x="ANY", type="Features"),
function(x, type, sparse=FALSE, ...) {
  clazz <- class(type)[1]
  if (missing(sparse)) {
    sparse <- grep('sparse', clazz, ignore.case=TRUE)
  }
  
  cclass <- gsub('sparse', '', clazz, ignore.case=TRUE)
  idx <- which(cclass == known.features)
  if (length(idx) != 1) {
    stop("Can't map class of features we are trying to copy: ", class(type))
  }
  
  
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
  features.info <- .kernel.map[[type]]$data
  if (is.null(features.info)) {
    stop("features <-> kernel mapping hosed")
  }
  
  clazz <- features.info$class
  fn <- features.info$cfun
  params <- extractParams(type, ..., .defaults=features.info$params)
  
  if (sparse) {
    fn <- paste(fn, 'sparse', sep="_")
    clazz <- paste("Sparse", clazz, sep="")
  } else {
    fn <- paste(fn, 'dense', sep="_")
  }
  
  ## TODO: Make this switching-on-kernel-type more elegant
  basefn <- features.info$cfun
  if (basefn == 'features_create_poly') {
    sg.ptr <- .Call(fn, x, n.obs, n.dims, params$degree, params$normalize)
  } else if (basefn == 'features_create_simple') {
    sg.ptr <- .Call(fn, x, n.obs, n.dims)
  } else {
    stop(basefn, " not implemented yet")
  }
  
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
