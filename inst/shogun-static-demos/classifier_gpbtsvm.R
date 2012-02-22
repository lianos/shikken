# In this example a two-class support vector machine classifier is trained on a
# toy data set and the trained classifier is used to predict labels of test
# examples. As training algorithm Gradient Projection Decomposition Technique
# (GPDT) is used with SVM regularization parameter C=1.2 and a Gaussian
# kernel of width 2.1 and 10MB of kernel cache. 
# 
# For more details on GPDT solver see http://dm.unife.it/gpdt 
#  
#    

library("sg")

size_cache <- 10
C <- 10
epsilon <- 1e-5
use_bias <- TRUE
width <- 2.1

fm_train_real <- t(as.matrix(read.table('../data/fm_train_real.dat')))
fm_test_real <- t(as.matrix(read.table('../data/fm_test_real.dat')))
label_train_twoclass <- as.real(as.matrix(read.table('../data/label_train_twoclass.dat')))

# GPBTSVM
print('GPBTSVM')

dump <- sg('set_features', 'TRAIN', fm_train_real)
dump <- sg('set_kernel', 'GAUSSIAN', 'REAL', size_cache, width)

dump <- sg('set_labels', 'TRAIN', label_train_twoclass)
dump <- sg('new_classifier', 'GPBTSVM')
dump <- sg('svm_epsilon', epsilon)
dump <- sg('c', C)
dump <- sg('svm_use_bias', use_bias)
dump <- sg('train_classifier')

dump <- sg('set_features', 'TEST', fm_test_real)
result <- sg('classify')
