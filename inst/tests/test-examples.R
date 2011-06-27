context("Shogun Examples")

test_that("classifier_libsvm_modular", {
  dat.train <- as.matrix(read.table(shikkenTestData('fm_train_real.dat', 'toy')))
  dat.test <- as.matrix(read.table(shikkenTestData('fm_test_real.dat', 'toy')))
  labels <- read.table(shikkenTestData('label_train_twoclass.dat'))[,1]
  
  svm <- SVM(dat.train, labels, kernel='gaussian', width=2.1, C=1.017,
             epsilon=1e-5, threads=2, svm.engine='libsvm')
  
  preds.train <- predict(svm)
  preds.test <- predict(svm, dat.test)
})
