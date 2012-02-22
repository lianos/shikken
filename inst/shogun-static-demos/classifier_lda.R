# In this example a linear two-class classifier is trained based on the Linear 
# Discriminant Analysis (LDA) from a toy 2-dimensional examples. The trained 
# LDA classifier is used to predict test examples. Note that the LDA classifier
# is optimal under the assumption that both classes are Gaussian distributed with equal
# co-variance. For more details on the LDA see e.g.
#              http://en.wikipedia.org/wiki/Linear_discriminant_analysis
# 

library("sg")

fm_train_real <- t(as.matrix(read.table('../data/fm_train_real.dat')))
fm_test_real <- t(as.matrix(read.table('../data/fm_test_real.dat')))
label_train_twoclass <- as.real(as.matrix(read.table('../data/label_train_twoclass.dat')))

# LDA
print('LDA')

dump <- sg('set_features', 'TRAIN', fm_train_real)
dump <- sg('set_labels', 'TRAIN', label_train_twoclass)
dump <- sg('new_classifier', 'LDA')
dump <- sg('train_classifier')

dump <- sg('set_features', 'TEST', fm_test_real)
result <- sg('classify')
