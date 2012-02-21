##' Decision = trcrossprod(wVector(x, data), [new]data) + bias(x)
wVector <- function(x, data) {
  stopifnot(inherits(x, 'KernelMachine'))
  if (missing(data)) stop("Data used in training is required to calculate W")
  if (!trained(x)) stop("Train machine prior to retrieve wVector")
  
  ## asv <- mapply(function(sv.idx, a) {
  ##   data[sv.idx,] * a
  ## }, supportVectors(x), alphas(x))
  ## ## mapply returns a transposed matrix (columns are the examples)
  ## w <- rowSums(asv)
  
  alphas(x) %*% data[supportVectors(x), , drop=FALSE]
}

## setMethod("kernel", c(x="KernelMachine"),
## function(x, ...) {
##   ## I don't think there is a need to up the SG_REF-count
##   # upRefCount(x@Kernel@sg.ptr)
##   x@kernel
## })
## 
## setReplaceMethod("kernel", "KernelMachine", function(x, value) {
##   stopifnot(inherits(value, 'Kernel'))
##   .Call("kmachine_set_kernel", x@sg.ptr, value@sg.ptr)
##   x@kernel <- kernel
##   x@cache[['trained']] <- FALSE
##   x
## })
## 
## setMethod("supportVectors", c(x="KernelMachine"),
## function(x, as.index, ...) {
##   if (!trained(x)) {
##     stop("Machine needs to be trained before SVs are set")
##   }
##   
##   ## Returns C-based indices of the support vectors
##   .Call("kmachine_support_vectors", x@sg.ptr, PACKAGE="shikken") + 1L
## })
## 
## 
## setMethod("alphas", c(x="KernelMachine"),
## function(x, ...) {
##   if (!trained(x)) {
##     stop("Machine needs to be trained before alphas are set")
##   }
##   .Call("kmachine_alphas", x@sg.ptr, PACKAGE="shikken")
## })
## 
## setMethod("bias", c(x="KernelMachine"),
## function(x, ...) {
##   .Call("kmachine_bias", x@sg.ptr, PACKAGE="shikken")
## })
## 
## setMethod("features", c(x="KernelMachine"),
## function(x, ...) {
##   features(kernel(x))
## })

