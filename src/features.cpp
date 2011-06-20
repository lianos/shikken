#include <features.h>

using namespace shogun;

// shogun features are stored in column order, where each column denotes
// a feature vector (just like "normal" R)
// columns are linear in memory
// 2nd param is the number of features in matrix
// 3rd param is the number of vectors in matrix
// in R, typically rows are observations and columns are features
RcppExport SEXP create_dense_features(SEXP data_, SEXP dims_, SEXP type_) {
BEGIN_RCPP
  Rcpp::NumericVector data(data_);
  Rcpp::NumericVector dims(dims_);
  
  // NOTE: There msut be an easy way to extract the double* ptr from 
  //       Rcpp::NumericVector without doing the copying below
  //       It's probably: float64_t* data.get_ref();
  float64_t* matrix = new float64_t[data.size()];
  for (int32_t i = 0; i < data.size(); i++) {
    matrix[i] = data[i];
  }
  // float64_t* matrix = data.get_ref();
  
  CSimpleFeatures<float64_t>* features = new CSimpleFeatures<float64_t>();
  features->set_feature_matrix(matrix, dims[1], dims[0]);
  
  SG_REF(features);
  
  Rcpp::XPtr<CFeatures> ptr(features);
  return ptr;
END_RCPP
}

RcppExport SEXP create_sparse_features(SEXP data_, SEXP dims_, SEXP type_) {
BEGIN_RCPP
  return R_NilValue;
END_RCPP
}

