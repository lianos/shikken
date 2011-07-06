##' Assign values for variables found in ... that are defined in .defaults.
##' 
##' If no variable is found in ..., then the one from .defaults is taken.
##' `key` is the key into .defaults to get variables for.
##'
##' This is used so far in getting defaults for kernel and feature object
##' construction.
##' 
##' Default values are provided for each kernel parameter. The parameters returned
##' from this function are gauranteed to be of the correct type so they can be
##' confidently passed to the C routines
##'
##' @param kernel \code{character} The name of the kernel.
##' @param data The data matrix. This could be used to extract default values for
##' some kernel parameters, if we can get smart about engineering those.
##' @param ... parameter name=value pairs are searched in these variables that
##' will be used to override the paremeters of the same name for the kernel.
##'
##' @return A list of named parameter values.
extractParams <- function(data, ..., .defaults) {
  default.params <- .defaults
  stopifnot(is.list(default.params))
  # if (is.null(default.params)) {
  #   stop("Unknown key ", key, "in map with keys:\n",
  #        paste(names(.defaults), collapse=","))
  # }
  new.params <- default.params
  args <- list(...)

  for (name in names(default.params)) {
    def.param <- default.params[[name]]
    new.param <- args[[name]]
    if (is.null(new.param)) {
      new.params[[name]] <- def.param
    } else {
      ## Override default value
      if (class(def.param) != class(new.param)) {
        stop("Illegal type for ", key, ":", name, " ",
             class(new.param), " parameter.")
      }
      if (length(def.param) != length(new.param)) {
        stop("Illegal length for ", key, ":", name, " parameter ",
             "[", length(new.param))
      }
      new.params[[name]] <- new.param
    }
  }

  if (!all(names(new.params) %in% names(default.params))) {
    stop("Missing some paremeters for `", name, "` ...")
  }

  new.params
}
