fix.shogun.static.install <- function() {
  ## Check if *.so is in the "base" sg/libs directory, and if so
  ## make an architecture specific libs/r_arch directory and move
  ## the *.so in there.
  ## 
  ## This function expects that the current architecture R is running on
  ## is the architecture that `sg.so` was built for
  cat("... moving sg.so to appropriate place\n")
  
  r.arch <- .Platform$r_arch
  bad.so.path <- system.file('libs', 'sg.so', package="sg")
  if (!file.exists(bad.so.path)) {
    cat("sg.so not found, did you already fix this?\n")
  } else {
    lib.dir <- dirname(bad.so.path)
    cmd <- paste('file', bad.so.path)
    info <- system(cmd, intern=TRUE)
    arch.match <- regexpr(r.arch, info)
    if (arch.match > -1) {
      arch.dir <- file.path(lib.dir, r.arch)
      if (!dir.exists(arch.dir)) {
        if (dir.create(arch.dir)) {
          
        } else {
          warning("Could not create library directory ", arch.dir)
        }
      }
    } else {
      warning("sg.so architecture does not seem to match R_arch: ", r.arch,
              "\n")
    }
  }
}
