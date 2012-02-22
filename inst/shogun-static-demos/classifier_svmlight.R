# In this example a two-class support vector machine classifier is trained on a
# DNA splice-site detection data set and the trained classifier is used to predict
# labels on test set. As training algorithm SVM^light is used with SVM
# regularization parameter C=1.2 and the Weighted Degree kernel of degree 20 and
# the precision parameter epsilon=1e-5.
# 
# For more details on the SVM^light see
#  T. Joachims. Making large-scale SVM learning practical. In Advances in Kernel
#  Methods -- Support Vector Learning, pages 169-184. MIT Press, Cambridge, MA USA, 1999.
# 
# For more details on the Weighted Degree kernel see
#  G. Raetsch, S.Sonnenburg, and B. Schoelkopf. RASE: recognition of alternatively
#  spliced exons in C. elegans. Bioinformatics, 21:369-377, June 2005. 

library("sg")

size_cache <- 10
C <- 10
epsilon <- 1e-5
use_bias <- TRUE

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))
label_train_dna <- as.real(as.matrix(read.table('../data/label_train_dna.dat')))
degree <- 20

# SVM Light
dosvmlight <- function()
{
	print('SVMLight')

	dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
	dump <- sg('set_kernel',  'WEIGHTEDDEGREE', 'CHAR', size_cache, degree)

	dump <- sg('set_labels', 'TRAIN', label_train_dna)

	dump <- sg('new_classifier', 'SVMLIGHT')
	dump <- sg('svm_epsilon', epsilon)
	dump <- sg('c', C)
	dump <- sg('svm_use_bias', use_bias)
	dump <- sg('train_classifier')

	dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
	result <- sg('classify')
}
try(dosvmlight())
