# This is an example for the initialization of the PolyMatchString kernel on string data. 
# The PolyMatchString kernel sums over the matches of two stings of the same length and 
# takes the sum to the power of 'degree'. The strings consist of the characters 'ACGT' corresponding 
# to the DNA-alphabet. Each column of the matrices of type char corresponds to 
# one training/test example.

library("sg")

size_cache <- 10

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

# Poly Match String
print('PolyMatchString')

degree <- 3
inhomogene <- FALSE

dump <- sg('set_kernel', 'POLYMATCH', 'CHAR', size_cache, degree, inhomogene)

dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
km <- sg('get_kernel_matrix', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
km <- sg('get_kernel_matrix', 'TEST')
