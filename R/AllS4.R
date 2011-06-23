setClass("ShikkenObject", contains="VIRTUAL")

setGeneric("shogunPointers", function(x, ...) standardGeneric("shogunPointers"))
setMethod("shogunPointers", c(x="ShikkenObject"),
function(x, ...) {
  ## Default to returning names of all externptr objects
  slot.names <- slotNames(x)
  sg.ptrs <- character()
  is.ptr <- grep("\\.sg\\.ptr$", slot.names)
  if (length(is.ptr) > 0) {
    sg.ptrs <- slot.names[is.ptr]
  }
  sg.ptrs
})

setGeneric("disposeSO", function(x) standardGeneric("disposeSO"))
setMethod("disposeSO", c(x="ShikkenObject"),
function(x) {
  clazz <- class(x)[1]
  cat("Disposing", clazz, "...\n")
  for (slot.name in shogunPointers(x)) {
    ptr <- slot(x, slot.name)
    cat("  ...", slot.name, "\n")
    .Call("dispose_shogun_object", ptr)
  }
})
