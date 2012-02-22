# In this example a kernel matrix is computed for a given string data set. The
# CommWordString kernel is used to compute the spectrum kernel from strings that
# have been mapped into unsigned 16bit integers. These 16bit integers correspond
# to k-mers. To be applicable in this kernel the mapped k-mers have to be sorted.
# This is done using the SortWordString preprocessor, which sorts the indivual
# strings in ascending order. The kernel function basically uses the algorithm in
# the unix "comm" command (hence the name). Note that this representation is
# especially tuned to small alphabets (like the 2-bit alphabet DNA), for which it
# enables spectrum kernels of order up to 8. For this kernel the linadd speedups
# are quite efficiently implemented using direct maps.

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
dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
dump <- sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
dump <- sg('convert', 'TEST', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TEST')

dump <- sg('set_kernel', 'COMMSTRING', 'WORD', size_cache, use_sign, normalization)
km <- sg('get_kernel_matrix', 'TRAIN')
km <- sg('get_kernel_matrix', 'TEST')
