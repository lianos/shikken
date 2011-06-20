setGeneric("SVM", function(x, ...) standardGeneric("SVM"))
setMethod("SVM", c(x="formula"),
function(x, data=NULL, ..., subset, na.action=na.omit, scaled=TRUE) {
  cl <- match.call()
  m <- match.call(expand.dots=FALSE)
  if (is.matrix(eval(m$data, parent.frame()))) {
    m$data <- as.data.frame(data)
  }
  m$... <- NULL
  m$formula <- m$x
  m$x <- NULL
  m$scaled <- NULL
  m[[1]] <- as.name("model.frame")
  m <- eval(m, parent.frame())
  Terms <- attr(m, "terms")
  attr(Terms, "intercept") <- 0    ## no intercept
  
  x <- model.matrix(Terms, m)
  y <- model.extract(m, response)
  
  browser()
  
  if (length(scaled) == 1) {
    scaled <- rep(scaled, ncol(x))
  }
  if (any(scaled)) {
    remove <- unique(c(which(labels(Terms) %in% names(attr(x, "contrasts"))),
                       which(!scaled)))
    scaled <- !attr(x, "assign") %in% remove
  }
  
  ret <- SVM(x, y, scaled=scaled, ...)
  # kcall(ret) <- cl
  # attr(Terms,"intercept") <- 0 ## no intercept
  # terms(ret) <- Terms
  
  if (!is.null(attr(m, "na.action"))) {
    n.action(ret) <- attr(m, "na.action")
  }
  
  ret
})

setMethod("SVM", c(x="vector"),
function(x, ...) {
  SVM(as.matrix(x), ...)
})

setMethod("SVM", c(x="matrix"),
function(x, y=NULL, kernel="rbf", kparams="automatic", type=NULL, scaled=TRUE,
         C=1, nu=0.2, epsilon=0.1, class.weights=NULL, cache=40,
         ..., subset, na.action=na.omit) {
  if (missing(y) || is.null(y)) {
    stop("Labels (y) is required.")
  }
  if (is.null(type)) {
    type <- guessLearningTypeFromLabels(y)
  }
  kernel <- createKernel(kernel, kparams, scaled=scaled, ...)
  y <- createLabels(y, type=type, ...)
})

