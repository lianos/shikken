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
  .Call("shogun_threads", NULL, PACKAGE="shikken")
})

setMethod("threads", c(x="numeric"),
function(x, ...) {
  x <- as.integer(x)
  if (x == threads()) {
    return(invisible(x))
  }
  
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
    x <- .Call("shogun_threads", x, PACKAGE="shikken")
  }
  
  invisible(x)
})

setMethod("threads", c(x="LearningMachine"),
function(x, ...) {
  ## .Call("get_num_threads", x@sg.ptr, PACKAGE="shikken")
  x@num.threads
})

setReplaceMethod("threads", "LearningMachine", function(x, value) {
  value <- as.integer(value)
  stopifnot(isSingleInteger(x))
  x@num.threads <- value
  x
})

setThreads <- function(n) {
  if (missing(n)) {
    
  }
}