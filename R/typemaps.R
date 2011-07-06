## who needs SWIG when you've got a list of lists?
.data.map <- list(
  simple=list(
    class="SimpleFeatures",
    cfun="features_create_simple",
    params=list()),
  polynomial=list(
    class='PolyFeatures',
    cfun="features_create_poly",
    params=list(degree=2L, normalize=TRUE)),
  string=list(
    class="StringFeatures",
    cfun="features_create_string",
    params=list(alphabet="DNA"))
)

.kernel.map <- list(
  gaussian=list(
    class='GaussianKernel',
    cfun='create_kernel_gaussian',
    params=list(width=0.5),
    data=.data.map$simple),
  linear=list(
    class='LinearKernel',
    cfun='create_kernel_linear',
    params=list(),
    data=.data.map$simple),
  sigmoid=list(
    class='SigmoidKernel',
    cfun='create_kernel_sigmoid'
    params=list(gamma=1, coef0=1),
    data=.data.map$simple),
  polynomial=list(
    class='PolyKernel',
    cfun='create_kernel_polynomial',
    params=list(degree=2L, inhomogeneous=TRUE),
    data=.data.map$polynomial),
  weighted.degree.string=list(
    class="WeightedDegreeStringKernel",
    cfun='create_kernel_weighted_degree_string',
    params=list(weights=1, degree=2L, alphabet="DNA"),
    data=.data.map$string)
)

