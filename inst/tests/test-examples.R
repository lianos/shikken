context("Shogun Examples")

iris.2class <- local({
  set <- subset(iris, Species == 'setosa')
  ver <- subset(iris, Species == 'versicolor')
  rbind(set, ver)
})
iris.x <- as.matrix(iris.2class[, 1:4])
iris.y <- as.numeric(iris.2class[, 5])
iris.y[iris.y == 2] <- -1

test_that("gaussian 'dummy' examples translates correctly", {
  ## http://www.shogun-toolbox.org/doc/developer_tutorial.html
  pred.y = .Call("gaussian_kernel_example", iris.x, dim(iris.x), iris.y,
                 PACKAGE="shikken")
  table(sign(pred.y), iris.y)
})

test_that("modular pieces work on gaussian example", {
  iris.kernel <- Kernel(iris.x, 'gaussian')
  svm <- SVM(Species ~ ., iris.2class)
})

