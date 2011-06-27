refCount <- function(x) {
  stopifnot(is(x, 'externalptr'))
  .Call("shogun_ref_count", x, PACKAGE="shikken")
}

upRefCount <- function(x) {
  stopifnot(is(x, 'externalptr'))
  .Call("shogun_ref_count_up", x, PACKAGE="shikken")
}

##' Calls the equivalent of SG_UNREF on a pointer to a Shogun object.
##' 
##' This fnction shouldn't be called directly. For now the "finalizing"
##' routine is specified on the C-side of the library when shogun objects
##' are created and returned back to R
##' 
##' @param x An \code{externalptr} to a \code{CSObject}
downRefCount <- function(x) {
  cat("... disposing a shogun pointer\n")
  .Call("shogun_ref_count_down", x)
}

###############################################################################
## Previously
## setGeneric("shogunPointers", function(x, ...) {
##   standardGeneric("shogunPointers")
## })
## 
## setMethod("shogunPointers", c(x="ShikkenObject"),
## function(x, ...) {
##   ## Default to returning names of all externptr objects
##   slot.names <- slotNames(x)
##   sg.ptrs <- character()
##   is.ptr <- grep("\\.sg\\.ptr$", slot.names)
##   if (length(is.ptr) > 0) {
##     sg.ptrs <- slot.names[is.ptr]
##   }
##   sg.ptrs
## })
## 
## setGeneric("disposeSO", function(x) standardGeneric("disposeSO"))
## setMethod("disposeSO", c(x="ShikkenObject"),
## function(x) {
##   clazz <- class(x)[1]
##   cat("Disposing", clazz, "...\n")
##   for (slot.name in shogunPointers(x)) {
##     ptr <- slot(x, slot.name)
##     cat("  ...", slot.name, "\n")
##     .Call("dispose_shogun_object", ptr)
##   }
## })
