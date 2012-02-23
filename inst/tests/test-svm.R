## context("Base SVM")

## test_that("this is a dummy test", {
##   expect_true(1 < 2)
## })

################################################################################
## From sg/demo/test-svm.R
meshgrid <- function(a,b) {
  list(x=outer(b*0,a,FUN="+"), y=outer(b,a*0,FUN="+"))
}

trySVM <- function(c, traindat, trainlab, ktype, dtype, size_cache,
                   wireframe=FALSE, testdata=NULL) {
  sg('set_features', 'TRAIN', traindat)
  sg('set_labels', 'TRAIN', trainlab)
  sg('set_kernel', ktype, dtype, size_cache)
  sg('new_classifier', 'LIBSVM')
  sg('c', c)

  sg('train_classifier')

  if (is.null(testdata)) {
    x1 <- (-49:+50)/10
    x2 <- (-49:+50)/10
    testdat <- meshgrid(x1,x2)
    testdat <- t(matrix(c(testdat$x, testdat$y),10000,2))
  } else {
    x1 <- testdat[1,]
    x2 <- testdat[2,]
  }

  sg('set_features', 'TEST', testdat)
  out <- sg('classify')

  z <- t(matrix(out, 100, 100))

  svm <- sg('get_svm')
  b <- svm[[1]]
  svs <- svm[[2]][,2]+1

  objective <- sg('get_svm_objective')
  print(objective)

  if (wireframe == TRUE) {
    ## for some reason plots only when done interactively
	  wireframe(z, shade = TRUE, aspect = c(61/87, 0.4),
              light.source = c(10,0,10))
  } else {
    image(x1,x2,z,col=topo.colors(1000))
    contour(x1,x2,z,add=T)
    cat(length(svs), 'svs:', svs, "\n")

    posSVs <- traindat[,trainlab==+1 & (1:ncol(traindat) %in% svs)]
    negSVs <- traindat[,trainlab==-1 & (1:ncol(traindat) %in% svs)]

    pos    <- traindat[,trainlab==+1 & !(1:ncol(traindat) %in% svs)]
    neg    <- traindat[,trainlab==-1 & !(1:ncol(traindat) %in% svs)]

    matplot(posSVs[1,],posSVs[2,], pch="+", col="red",add=T, cex=1.5)
    matplot(negSVs[1,],negSVs[2,], pch="-", col="red",  add=T, cex=2.0)

    matplot(pos[1,],pos[2,], pch="+", col="black",add=T, cex=1.5)
    matplot(neg[1,],neg[2,], pch="-", col="black",add=T, cex=2.0)
  }

  invisible(list(x1=x1, x2=x2, preds=out))
}

shSVM <- function(C, traindat, trainlab, kernel, cache=40,
                  wireframe=FALSE, testdat=NULL, ...) {
  if (ncol(traindat) == length(trainlab)) {
    traindat <- t(traindat)
  }
  stopifnot(nrow(traindat) == length(trainlab))
  model <- SVM(traindat, trainlab, kernel=kernel, C=C, cache=cache, ...)

  if (is.null(testdat)) {
    x1 <- (-49:+50)/10
    x2 <- (-49:+50)/10
    testdat <- meshgrid(x1,x2)
    testdat <- matrix(c(testdat$x, testdat$y), ncol=2)
  } else {
    x1 <- testdat[,1]
    x2 <- testdat[,2]
  }

  preds <- predict(model, testdat, "decision")
  z <- t(matrix(preds, 100, 100))

  svs <- SVindex(model)
  b <- bias(model)
  objective <- objective(model)
  print(objective)

  if (wireframe == TRUE) {
    ## for some reason plots only when done interactively
	  print(wireframe(z, shade = TRUE, aspect = c(61/87, 0.4),
                    light.source = c(10,0,10)))
  } else {
    image(x1,x2,z,col=topo.colors(1000))
    contour(x1,x2,z,add=T)
    cat(length(svs), 'svs:', svs, "\n")

    posSVs <- traindat[trainlab==+1 & (1:nrow(traindat) %in% svs),]
    negSVs <- traindat[trainlab==-1 & (1:nrow(traindat) %in% svs),]

    pos    <- traindat[trainlab==+1 & !(1:nrow(traindat) %in% svs),]
    neg    <- traindat[trainlab==-1 & !(1:nrow(traindat) %in% svs),]

    matplot(posSVs[,1],posSVs[,2], pch="+", col="red",add=T, cex=1.5)
    matplot(negSVs[,1],negSVs[,2], pch="-", col="red",  add=T, cex=2.0)

    matplot(pos[,1],pos[,2], pch="+", col="black",add=T, cex=1.5)
    matplot(neg[,1],neg[,2], pch="-", col="black",add=T, cex=2.0)
    title("shSVM")
  }

  model
}

## Examples
if (FALSE) {
  graphics.off()
  C <- 1000
  dims <- 2
  num <- 50
  traindat <- matrix(c(rnorm(dims*num)-1,rnorm(dims*num)+1),dims,2*num)
  trainlab <- c(rep(-1,num),rep(1,num))

  xx <- trySVM(C, traindat, trainlab, 'SIGMOID', 'REAL', 50)
  yy <- shSVM(C, traindat, trainlab, 'sigmoid')

  ## newplot()
  trySVM(C, traindat, trainlab, 'LINEAR', 'REAL', 100)
  yy <- shSVM(C, traindat, trainlab, 'linear', 100)
  ## newplot()

  trySVM(C, traindat, trainlab, 'GAUSSIAN', 'REAL', 40)
  yy <- shSVM(C, traindat, trainlab, 'gaussian', 40,
              wireframe=TRUE)

  shSVM(C, traindat, trainlab, 'gaussian', cache=40)
}

## test_that("sg svm classification example is comparable", {


## })

