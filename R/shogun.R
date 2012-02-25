sgg <- function(cmd, ...) {
  if (isTRUE(shikkenEnv()$trace.sg)) {
    arg1 <- tryCatch(..1, error=function(e) NULL)
    arg2 <- tryCatch(..2, error=function(e) NULL)
    if (!(isSingleNumber(arg1) || isSingleString(arg1) || isTRUEorFALSE(arg1))) {
      arg1 <- NULL
    }
    if (!(isSingleNumber(arg2) || isSingleString(arg2) || isTRUEorFALSE(arg2))) {
      arg2 <- NULL
    }
    cat("sg:", cmd, arg1, arg2, "\n")
  }
  
  sg(cmd, ...)
}

## Returns answer from enumerated lists in sg help, eg:
## 
## R> sg('help', 'new_svm')
##    ...
##    sg('new_svm', 'LIBSVM_ONECLASS|LIBSVM_MULTICLASS|...|KNN')
##
## This extracts the 'LIBSVM_ONECLASS|...|KNN' list into a character vector
parseShogunHelp <- function(cmd, ...) {
  stypes <- sg('help', cmd)
  stypes <- capture.output(sg('help', cmd))
  idx <- grep('\\|', stypes)
  if (!length(idx)) {
    stop("Can't parse sg help output for SVM types")
  }
  stypes <- tail(unlist(strsplit(stypes[idx], ' ')), 1)
  stypes <- unlist(strsplit(stypes, "|", fixed=TRUE))
  gsub("\\W", "", stypes, perl=TRUE)
}

shogunClassifiers <- function() {
  result <- parseShogunHelp('new_svm')
  result[grep('SVM', result)]
}

shogunRegressors <- function() {
  parseShogunHelp('new_regression')
}

