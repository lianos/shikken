context("Comparison vs. kernlab")

iris.2class <- local({
  set <- subset(iris, Species == 'setosa')
  ver <- subset(iris, Species == 'versicolor')
  rbind(set, ver)
})
iris.x <- as.matrix(iris.2class[, 1:4])
iris.y <- as.numeric(iris.2class[, 5])
iris.y[iris.y == 2] <- -1

test_that("shikken linear kernel == kernlab linear kernel ", {

})
