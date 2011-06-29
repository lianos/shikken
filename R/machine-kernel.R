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
  x@is.trained <- FALSE
  x
})

