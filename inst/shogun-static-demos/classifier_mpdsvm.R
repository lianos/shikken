# In this example a two-class support vector machine classifier is trained on a
# toy data set and the trained classifier is used to predict labels of test
# examples. As training algorithm the Minimal Primal Dual SVM is used with SVM
# regularization parameter C=1.2 and a Gaussian kernel of width 2.1 and 10MB of
# kernel cache and the precision parameter epsilon=1e-5.
# 
# For more details on the MPD solver see 
#  Kienzle, W. and B. Schölkopf: Training Support Vector Machines with Multiple
#  Equality Constraints. Machine Learning: ECML 2005, 182-193. (Eds.) Carbonell,
#  J. G., J. Siekmann, Springer, Berlin, Germany (11 2005)

library("sg")

size_cache <- 10
C <- 10
epsilon <- 1e-5
use_bias <- TRUE
width <- 2.1

fm_train_real <- t(as.matrix(read.table('../data/fm_train_real.dat')))
fm_test_real <- t(as.matrix(read.table('../data/fm_test_real.dat')))
label_train_twoclass <- as.real(as.matrix(read.table('../data/label_train_twoclass.dat')))


# MPDSVM
print('MPDSVM')

dump <- sg('set_features', 'TRAIN', fm_train_real)
dump <- sg('set_kernel', 'GAUSSIAN', 'REAL', size_cache, width)

dump <- sg('set_labels', 'TRAIN', label_train_twoclass)
dump <- sg('new_classifier', 'MPDSVM')
dump <- sg('svm_epsilon', epsilon)
dump <- sg('c', C)
dump <- sg('svm_use_bias', use_bias)
dump <- sg('train_classifier')

dump <- sg('set_features', 'TEST', fm_test_real)
result <- sg('classify')
