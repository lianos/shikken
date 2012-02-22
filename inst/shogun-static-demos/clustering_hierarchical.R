# In this example an agglomerative hierarchical single linkage clustering method
# is used to cluster a given toy data set. Starting with each object being
# assigned to its own cluster clusters are iteratively merged. Here the clusters
# are merged that have the closest (minimum distance, here set via the Euclidean
# distance object) two elements.

library("sg")

fm_train <- t(as.matrix(read.table('../data/fm_train_real.dat')))

# Hierarchical
print('Hierarchical')

merges=3

dump <- sg('set_features', 'TRAIN', fm_train)
dump <- sg('set_distance', 'EUCLIDIAN', 'REAL')
dump <- sg('new_clustering', 'HIERARCHICAL')
dump <- sg('train_clustering', merges)

result <- sg('get_clustering')
merge_distances <- result[[1]]
pairs <- result[[2]]
