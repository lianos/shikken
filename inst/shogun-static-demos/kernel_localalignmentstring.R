# This is an example for the initialization of the local alignment kernel on 
# DNA sequences, where each column of the matrices of type char corresponds to 
# one training/test example. 

library("sg")

size_cache <- 10

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

# Local Alignment String
print('LocalAlignmentString')

dump <- sg('set_kernel', 'LOCALALIGNMENT', 'CHAR', size_cache)

dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
km <- sg('get_kernel_matrix', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
km <- sg('get_kernel_matrix', 'TEST')
