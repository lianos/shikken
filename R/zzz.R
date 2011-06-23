.onLoad <- function(libname, pkgname) {
  assign('.SHIKKEN_CONFIG', list(), .GlobalEnv)
  initShikken()
}

.Last.lib <- function(libpath) {
  cat("Exiting shogun ...\n")
  exitShikken()
}