sgg <- function(cmd, ...) {
  arg1 <- tryCatch(..1, error=function(e) NULL)
  if (!(isSingleNumber(arg1) || isSingleString(arg1))) {
    arg1 <- NULL
  }
  cat("sg:", cmd, arg1, "\n")
  sg(cmd, ...)
}

parseShogunHelp <- function(cmd, ...) {
  stypes <- sg('help', cmd)
  stypes <- capture.output(sg('help', 'new_svm'))
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
  result <- parseShogunHelp('new_regression')
}

