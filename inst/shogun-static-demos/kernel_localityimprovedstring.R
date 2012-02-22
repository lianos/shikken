# This example initializes the locality improved string kernel. The locality improved string 
# kernel is defined on sequences of the same length and inspects letters matching at 
# corresponding positions in both sequences. The kernel sums over all matches in windows of 
# length l and takes this sum to the power of 'inner_degree'. The sum over all these 
# terms along the sequence is taken to the power of 'outer_degree'. 

library("sg")

size_cache <- 10

fm_train_dna <- as.matrix(read.table('../data/fm_train_dna.dat'))
fm_test_dna <- as.matrix(read.table('../data/fm_test_dna.dat'))

# Locality Improved String
print('LocalityImprovedString')

length <- 5
inner_degree <- 5
outer_degree <- inner_degree+2

dump <- sg('set_kernel', 'LIK', 'CHAR', size_cache, length, inner_degree, outer_degree)

dump <- sg('set_features', 'TRAIN', fm_train_dna, 'DNA')
km <- sg('get_kernel_matrix', 'TRAIN')

dump <- sg('set_features', 'TEST', fm_test_dna, 'DNA')
km <- sg('get_kernel_matrix', 'TEST')

