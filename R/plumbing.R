## TODO: Get initShikken and exitShikken to be called onLoad and onUnload 
## of package

# .SHIKKEN_CONFIG <- list()

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

initShikken <- function(force=FALSE) {
  is.initialized <- shikkenEnv('is.initialized')
  is.initialized <- !(is.null(is.initialized) || !is.initialized)
  if (!is.initialized) {
    cat("Initializing shogun ...\n")
    .Call("init_shikken", PACKAGE="shikken")
    shikkenEnv(is.initialized=TRUE)
  } else if (is.initialized && force) {
    cat("Forcing a re-initialization is probably a bad idea ...?\n")
    .Call("init_shikken", PACKAGE="shikken")
  }
  invisible(NULL)
}

exitShikken <- function() {
  .Call("exit_shikken", PACKAGE="shikken")
  shikkenEnv(is.initialized=FALSE)
}

.onLoad <- function(libname, pkgname) {
  assign('.SHIKKEN_CONFIG', list(), .GlobalEnv)
  initShikken()
}

.Last.lib <- function(libpath) {
  cat("Exiting shogun ...\n")
  exitShikken()
}