.onLoad <- function(libname, pkgname) {
  assign('.SHIKKEN_CONFIG', list(), .GlobalEnv)
  ## initShikken()  
  
  term <- Sys.getenv()['TERM']
  if (is.na(term) || length(grep('color', term, ignore.case=TRUE)) == 0) {
    sg('syntax_highlight', 'OFF')
  }
}

