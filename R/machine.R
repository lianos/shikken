## TODO: Implement trained() logical method on static learning machines

supportedMachineTypes <- function() {
  # c('classification', '2-class', '1-class', 'multi-class', 'regression')
  c('1-class', '2-class', 'multi-class', 'regression')
}

isClassificationMachine <- function(x, ...) {
  if (inherits(x, 'Machine')) {
    x <- x@type
  }
  if (inherits(x, 'Labels')) {
    x <- tolower(class(x)[1L])
  }
  if (!is.character(x)) {
    stop("x needs to be a Machine or character")
  }
  length(grep('class', x) > 0L)
}

isRegressionMachine <- function(x, ...) {
  if (inherits(x, 'Labels')) {
    return(!isClassificationMachine(x))
  }
  if (inherits(x, 'Machine')) {
    x <- x@type
  }
  if (!is.character(x)) {
    stop("x needs to be a Machine or character")
  }
  length(grep('regress', x) > 0L)
}

