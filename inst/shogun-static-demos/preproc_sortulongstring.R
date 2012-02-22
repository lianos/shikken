# In this example a kernel matrix is computed for a given string data set. The
# CommUlongString kernel is used to compute the spectrum kernel from strings that
# have been mapped into unsigned 64bit integers. These 64bit integers correspond
# to k-mers. To be applicable in this kernel the mapped k-mers have to be sorted.
# This is done using the SortUlongString preprocessor, which sorts the indivual
# strings in ascending order. The kernel function basically uses the algorithm in
# the unix "comm" command (hence the name). Note that this representation enables
# spectrum kernels of order 8 for 8bit alphabets (like binaries) and order 32 for
# 2-bit alphabets like DNA. For this kernel the linadd speedups are implemented
# (though there is room for improvement here when a whole set of sequences is
# ADDed) using sorted lists.

library("sg")

size_cache <- 10

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

order <- 3
gap <- 0
reverse <- 'n'
use_sign <- FALSE
normalization <- 'FULL'

# Comm Ulong String
print('CommUlongString')

dump <- sg('add_preproc', 'SORTULONGSTRING')
dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
dump <- sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'ULONG', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
dump <- sg('convert', 'TEST', 'STRING', 'CHAR', 'STRING', 'ULONG', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TEST')

dump <- sg('set_kernel', 'COMMSTRING', 'ULONG', size_cache, use_sign, normalization)
km <- sg('get_kernel_matrix', 'TRAIN')
km <- sg('get_kernel_matrix', 'TEST')
