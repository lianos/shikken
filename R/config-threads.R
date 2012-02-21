## Taken from multicore
detectCores <- function(all.tests = FALSE) {
  # feel free to add tests - those are the only ones I could test [SU]
  systems <- list(
    darwin  = "/usr/sbin/sysctl -n hw.ncpu 2>/dev/null",
    linux   = "grep processor /proc/cpuinfo 2>/dev/null|wc -l",
    irix    = c("hinv |grep Processors|sed 's: .*::'", "hinv|grep '^Processor '|wc -l"),
    solaris = "/usr/sbin/psrinfo -v|grep 'Status of.*processor'|wc -l")
  for (i in seq(systems)) {
    if (all.tests || length(grep(paste("^", names(systems)[i], sep=''), R.version$os))) {
      for (cmd in systems[i]) {
        a <- gsub("^ +","",system(cmd, TRUE)[1])
        if (length(grep("^[1-9]", a))) return(as.integer(a))
      }
    }
  }
  NA
}

shThreads <- function(x, force=FALSE) {
  if (missing(x)) {
    ## TODO: Query shogun for then number of threads to use.
    return(NULL)
  }
  if (!is.numeric(x)) {
    stop("numeric parameter required for threads")
  }
  x <- as.integer(x)[1L]
  stopifnot(isSingleInteger(x))
  if (!force) {
    if (.Platform$OS.type == 'windows') {
      message("shogun on windows does not support mult-threaded functionality")
      x <- NA
    } else {
      ncores <- detectCores()
      if (is.na(ncores)) {
        message("problem detecting number of cores ... multithreading not supported")
        x <- NA_integer_
      }
      if (ncores < x) {
        message("n.threads > number of detected cores, setting threads to n.cores")
        x <- ncores
      }
    }
  }
  if (!is.na(x)) {
    sgg('threads', x)
  }
  invisible(x)
}
