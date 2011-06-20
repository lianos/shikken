#include <shikken.h>

extern "C" {

// shogun features are stored in column order, where each column denotes
// a feature vector (just like "normal" R)
// columns are linear in memory
// 2nd param is the number of features in matrix
// 3rd param is the number of vectors in matrix
// in R, typically rows are observations and columns are features
SEXP create_simple_features(SEXP data_, SEXP dims_) {
  Rcpp::NumericVector data(data_);
  Rcpp::NumericVector dims(dims_);
  
  // NOTE: There msut be an easy way to extract the double* ptr from 
  //       Rcpp::NumericVector without doing the copying below
  float64_t* matrix = new float64_t[values.size()];
  for (int32_t i = 0; i < data.size(); i++) {
    matrix[i] = data[i];
  }
  
  CSimpleFeatures<float64_t>* features = new CSimpleFeatures<float64_t>();
  features->set_feature_matrix(matrix, dims[1], dims[0]);
  
  // TODO: Return an externalptr to features
  return R_NilValue;
}


}