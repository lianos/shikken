# In this example a support vector regression algorithm is trained on a
# real-valued toy data set. The underlying library used for the SVR training is
# LIBSVM. The SVR is trained with regularization parameter C=1 and a gaussian
# kernel with width=2.1.
# 
# For more details on LIBSVM solver see http://www.csie.ntu.edu.tw/~cjlin/libsvm/ .

library("sg")

size_cache <- 10
C <- 10
tube_epsilon <- 1e-2
width <- 2.1

fm_train <- t(as.matrix(read.table('../data/fm_train_real.dat')))
fm_test <- t(as.matrix(read.table('../data/fm_test_real.dat')))
label_train <- as.real(as.matrix(read.table('../data/label_train_twoclass.dat')))

# LibSVR
print('LibSVR')

dump <- sg('set_features', 'TRAIN', fm_train)
dump <- sg('set_kernel', 'GAUSSIAN', 'REAL', size_cache, width)

dump <- sg('set_labels', 'TRAIN', label_train)
dump <- sg('new_regression', 'LIBSVR')
dump <- sg('svr_tube_epsilon', tube_epsilon)
dump <- sg('c', C)
dump <- sg('train_regression')

dump <- sg('set_features', 'TEST', fm_test)
result <- sg('classify')
