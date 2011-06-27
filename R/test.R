## Functions to help with testing

shikkenTestData <- function(fn.name, subdir='toy', base.path=NULL) {
  if (is.null(base.path)) {
    base.path <- Sys.getenv('SHIKKEN_TESTDATA_BASE')
  }
  if (is.null(base.path)) {
    stop("Set SHIKKEN_TESTDATA_BASE environment variable")
  }
  
  fp <- file.path(base.path, subdir, fn.name)
  if (!file.exists(fp)) {
    stop("File cannot be found: ", fp)
  }
  
  fp
}