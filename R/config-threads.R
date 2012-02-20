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


## Threads information is stored in the global `Parallel * sg_parallel` object
setMethod("threads", c(x="missing"),
function(x, ...) {
  ## .Call("shogun_threads", NULL, PACKAGE="shikken")
  NULL
})

setMethod("threads", c(x="numeric"),
function(x, force=FALSE, ...) {
  x <- as.integer(x)
  stopifnot(isSingleInteger(x))
  
  if (force) {
    sg('threads', x)
  } else {
    if (.Platform$OS.type == 'windows') {
      message("shogun on windows does not support mult-threaded functionality")
      x <- NA
    } else {
      ncores <- detectCores()
      if (is.na(ncores)) {
        message("problem detecting number of cores ... multithreading not supported")
        return(invisible(ncores))
      }
      if (ncores < x) {
        message("n.threads > number of detected cores, setting threads to n.cores")
        x <- ncores
      }
      ## x <- .Call("shogun_threads", x, PACKAGE="shikken")
      
    }
  }
  
  invisible(x)
})

