# In this example the k-means clustering method is used to cluster a given toy
# data set. In k-means clustering one tries to partition n observations into k
# clusters in which each observation belongs to the cluster with the nearest mean.
# The algorithm class constructor takes the number of clusters and a distance to
# be used as input. The distance used in this example is Euclidean distance.
# After training one can fetch the result of clustering by obtaining the cluster
# centers and their radiuses.

library("sg")

fm_train <- as.matrix(read.table('../data/fm_train_real.dat'))

# KMEANS
print('KMeans')

k <- 3
iter <- 1000

dump <- sg('set_distance', 'EUCLIDIAN', 'REAL')
dump <- sg('set_features', 'TRAIN', fm_train)
dump <- sg('new_clustering', 'KMEANS')
dump <- sg('train_clustering', k, iter)

result <- sg('get_clustering')
radi <- result[[1]]
centers <- result[[2]]
