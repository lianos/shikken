# .SHIKKEN_CONFIG <- list()

##' Get/set values in the global Shikken config object.
##' 
##' Global configuration options, and external library state information
##' is stored in the \code{.SHIKKEN_CONFIG} object.
##' 
##' This method is not exported on purpose.
##' 
##' @param Either no arguments (returns the current settings as a list).
##' A character vector returns the values of the variables named in the vector.
##' A parameter list, eg. \code{arg=1, something=2} sets the values of those
##' parameters into the configuration object.
##' 
##' @return Invisibly returns the values of the configuration before modification.
##' A subset of these values is only returned if the caller is querying for
##' specific objects by passing in a character vector.
shikkenEnv <- function(...) {
  config <- get('.SHIKKEN_CONFIG', .GlobalEnv)
  # config <- .SHIKKEN_CONFIG
  args <- list(...)
  arg.names <- names(args)
  
  if (length(args) == 0L) {
    return(config)
  }
  
  ## Only querying for values?
  if (all(unlist(lapply(args, is.character)))) {
    if (length(args) == 1) {
      ## return singleton
      ret.val <- config[[args[[1]]]]
    } else {
      ## return list of vars
      ret.val <- lapply(arg.names, function(name) config[[name]])
      names(ret.val) <- arg.names
    }
    return(ret.val)    
  }
  
  ## We want to set new variables -- ensure that all elements have names
  if (is.null(arg.names) || any(nchar(arg.names) == 0)) {
    stop("All arguments must be named")
  }
  new.config <- config
  for (name in arg.names) {
    new.config[[name]] <- args[[name]]
  }
  assign('.SHIKKEN_CONFIG', new.config, .GlobalEnv)
  # .SHIKKEN_CONFIG <- new.config
  invisible(config)
}

