setMethod("kernel", c(x="KernelMachine"),
function(x, ...) {
  ## I don't think there is a need to up the SG_REF-count
  # upRefCount(x@Kernel@sg.ptr)
  x@kernel
})

setReplaceMethod("kernel", "KernelMachine", function(x, value) {
  stopifnot(inherits(value, 'Kernel'))
  .Call("kmachine_set_kernel", x@sg.ptr, value@sg.ptr)
  x@kernel <- kernel
  x@var.cache[['trained']] <- FALSE
  x
})

setMethod("supportVectors", c(x="KernelMachine"),
function(x, as.index, ...) {
  if (!trained(x)) {
    stop("Machine needs to be trained before SVs are set")
  }
  .Call("kmachine_support_vectors", x@sg.ptr, PACKAGE="shikken") + 1L
})


setMethod("alphas", c(x="KernelMachine"),
function(x, ...) {
  if (!trained(x)) {
    stop("Machine needs to be trained before alphas are set")
  }
  .Call("kmachine_alphas", x@sg.ptr, PACKAGE="shikken")
})

setMethod("bias", c(x="KernelMachine"),
function(x, ...) {
  .Call("kmachine_bias", x@sg.ptr, PACKAGE="shikken")
})