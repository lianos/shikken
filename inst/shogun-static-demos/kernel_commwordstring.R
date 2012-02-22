# This is an example for the initialization of the CommWordString-kernel (aka
# Spectrum or n-gram kernel; its name is derived from the unix command comm). This kernel 
# sums over k-mere matches (k='order'). For efficient computing a preprocessor is used 
# that extracts and sorts all k-mers. If 'use_sign' is set to one each k-mere is counted 
# only once. 

library("sg")

size_cache <- 10

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

order <- 3
gap <- 0
reverse <- 'n'
use_sign <- FALSE
normalization <- 'FULL'


# Comm Word String
print('CommWordString')

dump <- sg('add_preproc', 'SORTWORDSTRING')
dump <- sg('set_kernel', 'COMMSTRING', 'WORD', size_cache, use_sign, normalization)

dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
dump <- sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TRAIN')
km <- sg('get_kernel_matrix', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
dump <- sg('convert', 'TEST', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TEST')
km <- sg('get_kernel_matrix', 'TEST')
