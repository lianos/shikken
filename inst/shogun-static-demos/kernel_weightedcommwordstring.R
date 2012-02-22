# The WeightedCommWordString kernel may be used to compute the weighted
# spectrum kernel (i.e. a spectrum kernel for 1 to K-mers, where each k-mer
# length is weighted by some coefficient \f$\beta_k\f$) from strings that have
# been mapped into unsigned 16bit integers.
# 
# These 16bit integers correspond to k-mers. To applicable in this kernel they
# need to be sorted (e.g. via the SortWordString pre-processor).
# 
# It basically uses the algorithm in the unix "comm" command (hence the name)
# to compute:
# 
# k({\bf x},({\bf x'})= \sum_{k=1}^K\beta_k\Phi_k({\bf x})\cdot \Phi_k({\bf x'})
# 
# where \f$\Phi_k\f$ maps a sequence \f${\bf x}\f$ that consists of letters in
# \f$\Sigma\f$ to a feature vector of size \f$|\Sigma|^k\f$. In this feature
# vector each entry denotes how often the k-mer appears in that \f${\bf x}\f$.
# 
# Note that this representation is especially tuned to small alphabets
# (like the 2-bit alphabet DNA), for which it enables spectrum kernels
# of order 8.
# 
# For this kernel the linadd speedups are quite efficiently implemented using
# direct maps.
# 

library("sg")

size_cache <- 10

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

order <- 3
gap <- 0
reverse <- 'n'
use_sign <- FALSE
normalization <- 'FULL'

# Weighted Comm Word String
print('WeightedCommWordString')

dump <- sg('add_preproc', 'SORTWORDSTRING')
dump <- sg('set_kernel', 'WEIGHTEDCOMMSTRING', 'WORD', size_cache, use_sign, normalization)

dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
dump <- sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TRAIN')
km <- sg('get_kernel_matrix', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
dump <- sg('convert', 'TEST', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse)
dump <- sg('attach_preproc', 'TEST')
km <- sg('get_kernel_matrix', 'TEST')
