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
function(x, y=NULL, kernel="linear", kparams="automatic", type=NULL,
         svm.engine=c('libsvm', 'svmlight'), scaled=TRUE, C=1, C.neg=C,
         nu=0.2, epsilon=0.1, class.weights=NULL, cache=40, ..., subset,
         na.action=na.omit) {
  if (missing(y) || is.null(y)) {
    stop("Labels (y) is required.")
  }
  
  if (nrow(x) != length(y)) {
    stop("Number of observations does not equal number of labels")
  }
  
  type <- matchLearningType(y, type)
  
  if (type != '2-class') {
    stop("Only 2-class classification is supported for now")
  }
  C <- as.numeric(C)
  if (!isSingleNumber(C)) {
    stop("Illegal value for C")
  }
  epsilon <- as.numeric(epsilon)
  if (!isSingleNumber(epsilon)) {
    stop("Illegal value for epsilon")
  }
  args <- list(...)
  if (is.null(args$threads)) {
    n.threads <- 1L
  } else {
    n.threads <- as.integer(args$threads)
  }
  
  svm.engine <- match.arg(svm.engine)
  kernel <- Kernel(x, kernel=kernel, params=kparams, scaled=scaled, ...)
  labels <- createLabels(y, type)
  
  old.threads <- threads()
  n.threads <- threads(n.threads)
  on.exit(threads(old.threads))
  
  sg.ptr <- .Call("svm_init", kernel@sg.ptr, labels@sg.ptr, C, epsilon, svm.engine)
  
  if (is.null(sg.ptr)) {
    stop("error occured while initializing svm")
  }
  
  ## get support vectors
  sv <- .Call("svm_support_vectors", sg.ptr, PACKAGE="shikken") + 1L
  obj <- .Call("svm_objective", sg.ptr, PACKAGE="shikken")
  alpha <- .Call("svm_alphas", sg.ptr, PACKAGE="shikken")
  
  new("SVM", sg.ptr=sg.ptr, kernel=kernel, labels=labels, type=type,
      engine=svm.engine, sv.index=sv, objective=obj, alpha=alpha,
      num.threads=n.threads, is.trained=TRUE)
})

setMethod("SVM", c(x="Features"),
function(x, ...) {

})

setMethod("SVM", c(x="Kernel"),
function(x, ...) {

})
