# In this example a kernelized version of ridge regression (KRR) is trained on a
# real-valued data set. The KRR is trained with regularization parameter tau=1e-6
# and a gaussian kernel with width=0.8.

library("sg")

size_cache <- 10
C <- 10
tube_epsilon <- 1e-2
width <- 2.1

fm_train <- t(as.matrix(read.table('../data/fm_train_real.dat')))
fm_test <- t(as.matrix(read.table('../data/fm_test_real.dat')))
label_train <- as.real(as.matrix(read.table('../data/label_train_twoclass.dat')))

# KRR
print('KRR')

tau <- 1e-6

dump <- sg('set_features', 'TRAIN', fm_train)
dump <- sg('set_kernel', 'GAUSSIAN', 'REAL', size_cache, width)

dump <- sg('set_labels', 'TRAIN', label_train)

dump <- sg('new_regression', 'KRR')
dump <- sg('krr_tau', tau)
dump <- sg('c', C)
dump <- sg('train_regression')

dump <- sg('set_features', 'TEST', fm_test)
result <- sg('classify')
