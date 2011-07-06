## The information here is used to specify which classes of objects are
## associated with their sister class, eg: what class of Kernel of features is
## used for a given class of Kernsl, etc.
## 
## The names() of these lists are the things that we pass around as identifies
## in shikken
## 
## $validate.input is a function to apply to a "raw" piece of data that 
## indicates whether it is appropriate for this Feature type
.feature.map <- list(
  simple=list(
    class="SimpleFeatures",
    class.sparse="SparseFeatures",
    cfun="features_create_simple_dense",
    cfun.sparse="features_create_simple_sparse",
    # validate.input=isNumericMatrix,
    params=list()),
  polynomial=list(
    class='PolyFeatures',
    class.sparse='SparsePolyFeatures',
    cfun="features_create_poly_dense",
    cfun.sparse="features_create_poly_sparse",
    # validate.input=isNumericMatrix,
    params=list(degree=2L, normalize=TRUE, hash.bits=2L)),
  string=list(
    class="StringFeatures",
    class.sparse=character(), ## no such thing?
    cfun="features_create_string",
    cfun.sparse=character(),
    # validate.input=is.character,
    params=list(alphabet="DNA"))
)


## class : The name of the S4 class of this kernel type
## cfun  : The base name of the c function that is used to make this kernel
## params : The parameters (with their defaults) for this kernel
## feature.type : the key into the .feature.map object for this type of kernel
.kernel.map <- list(
  gaussian=list(
    class='GaussianKernel',
    cfun='create_kernel_gaussian',
    params=list(width=0.5),
    feature.type='simple'),
  linear=list(
    class='LinearKernel',
    cfun='create_kernel_linear',
    params=list(),
    feature.type='simple'),
  sigmoid=list(
    class='SigmoidKernel',
    cfun='create_kernel_sigmoid',
    params=list(gamma=1, coef0=1),
    feature.type='simple'),
  polynomial=list(
    class='PolyKernel',
    cfun='create_kernel_polynomial',
    params=list(degree=2L, inhomogeneous=TRUE),
    feature.type='polynomial'),
  weighted.degree.string=list(
    class="WeightedDegreeStringKernel",
    cfun='create_kernel_weighted_degree_string',
    params=list(weights=1, degree=2L, alphabet="DNA"),
    feature.type='string')
)

