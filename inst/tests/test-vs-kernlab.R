context("Comparison vs. kernlab")
library(kernlab)

iris.2class <- local({
  set <- subset(iris, Species == 'setosa')
  ver <- subset(iris, Species == 'versicolor')
  rbind(set, ver)
})

iris.x <- scale(as.matrix(iris.2class[, 1:4]))
iris.y <- as.numeric(iris.2class[, 5])
iris.y[iris.y == 2] <- -1

set.seed(123)
ho <- createFolds(iris.y, 10)

iris.train <- lapply(ho, function(idxs) {
  list(x=iris.x[-idxs,], y=iris.y[-idxs])
})
iris.test <- lapply(ho, function(idxs) {
  list(x=iris.x[idxs,], y=iris.y[idxs])
})

test_that("linear kernel", {
  for (i in 1:length(iris.train)) {
    s <- SVM(iris.train[[i]]$x, iris.train[[i]]$y, kernel='linear', C=1,
             svm.engine="libsvm")
    k <- ksvm(iris.train[[i]]$x, iris.train[[i]]$y, scaled=FALSE, C=1,
              kernel='vanilladot', type="C-svc")

    ## training error
    expect_equal(table(predict(s), iris.train[[i]]$y),
                 table(predict(k), iris.train[[i]]$y))
    ## test error
    expect_equal(table(predict(s, iris.test[[i]]$x), iris.test[[i]]$y),
                 table(predict(k, iris.test[[i]]$x), iris.test[[i]]$y))
  }
})
