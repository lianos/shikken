# This example shows how to use the Perceptron algorithm for training a
# two-class linear classifier, i.e.  y = sign( <x,w>+b). The Perceptron algorithm
# works by iteratively passing though the training examples and applying the
# update rule on those examples which are misclassified by the current
# classifier. The Perceptron update rule reads
# 
#   w(t+1) = w(t) + alpha * y_t * x_t
#   b(t+1) = b(t) + alpha * y_t
# 
# where (x_t,y_t) is feature vector and label (must be +1/-1) of the misclassified example
#       (w(t),b(t)) are the current parameters of the linear classifier
#       (w(t+1),b(t+1)) are the new parameters of the linear classifier
#       alpha is the learning rate. 
# 
# The Perceptron algorithm iterates until all training examples are correctly
# classified or the prescribed maximal number of iterations is reached. 
# 
# The learning rate and the maximal number of iterations can be set by
#   sg('set_perceptron_parameters', alpha, max_iter);
# 

library("sg")

size_cache <- 10
C <- 10
epsilon <- 1e-5
use_bias <- TRUE

fm_train_real <- as.matrix(read.table('../data/fm_train_real.dat'))
fm_test_real <- as.matrix(read.table('../data/fm_test_real.dat'))
label_train_twoclass <- as.real(as.matrix(read.table('../data/label_train_twoclass.dat')))

# Perceptron
print('Perceptron')

dump <- sg('set_features', 'TRAIN', fm_train_real)
dump <- sg('set_labels', 'TRAIN', label_train_twoclass)
dump <- sg('new_classifier', 'PERCEPTRON')
# often does not converge
#dump <- sg('train_classifier')

#dump <- sg('set_features', 'TEST', fm_test_real)
#result <- sg('classify')
