guessLearningTypeFromLabels <- function(y) {
  if (missing(y)) {
    stop("Insufficient parameters to guess machine type")
  }
  if (!is.null(type)) {
    type <- match.arg(type, supportedMachineTypes())
  } else {
    if (is.factor(y)) {
      nlevels <- length(levels(y))
      if (nlevels == 0) {
        stop("At least one level is required in your labels/factor.")
      } else if (nlevels == 1) {
        type <- '1-class'
      } else if (nlevels == 2) {
        type <- '2-class'
      } else {
        type <- 'multiclass'
      }
    } else {
      type <- 'regression'
    }
  }
  
  if (type == 'classification') {
    type <- '2-class'
  }
  
  type
}