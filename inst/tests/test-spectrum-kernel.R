context("Spectrum Kernels")

require(Biostrings)
data(promoters, package="shikken")

test_that("easy promoter classification task is easy", {
  x <- promoters
  y <- values(x)$class
  ss <- SVM(x, y, kernel="spectrum")
  expect_equal(predict(ss, x), y, info="Predicted labels do no match")
})

test_that("degree parameter used correctly", {
  x <- promoters
  y <- values(x)$class

  for (degree in 2:4) {
    ss <- SVM(x, y, kernel="spectrum", degree=as.numeric(degree))
    cat(sprintf("Prediction accuracy: %.2f\n",
                sum(predict(ss, x) == y) / length(y)))
  }

  ss <- SVM(x, y, kernel="spectrum", degree=3)
})


## test_that("manual spectrum")
