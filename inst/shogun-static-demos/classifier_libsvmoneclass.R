# In this example a one-class support vector machine classifier is trained on a
# toy data set. The training algorithm finds a hyperplane in the RKHS which
# separates the training data from the origin. The one-class classifier is
# typically used to estimate the support of a high-dimesnional distribution. 
# For more details see e.g. 
#   B. Schoelkopf et al. Estimating the support of a high-dimensional
#   distribution. Neural Computation, 13, 2001, 1443-1471. 
# 
# In the example, the one-class SVM is trained by the LIBSVM solver with the
# regularization parameter C=1.2 and the Gaussian kernel of width 2.1 and the
# precision parameter epsilon=1e-5 and 10MB of the kernel cache.
# 
# For more details on LIBSVM solver see http://www.csie.ntu.edu.tw/~cjlin/libsvm/ .
# 
# 

library("sg")

size_cache <- 10
svm_nu <- 0.1
epsilon <- 1e-5
use_bias <- TRUE
width <- 2.1

fm_train_real <- t(as.matrix(read.table('../data/fm_train_real.dat')))
fm_test_real <- t(as.matrix(read.table('../data/fm_test_real.dat')))

# LibSVMOneClass
print('LibSVMOneClass')

dump <- sg('set_features', 'TRAIN', fm_train_real)
dump <- sg('set_kernel', 'GAUSSIAN', 'REAL', size_cache, width)
dump <- sg('new_classifier', 'LIBSVM_ONECLASS')
dump <- sg('svm_epsilon', epsilon)
dump <- sg('svm_nu', svm_nu)
dump <- sg('svm_use_bias', use_bias)
dump <- sg('train_classifier')

dump <- sg('set_features', 'TEST', fm_test_real)
result <- sg('classify')
