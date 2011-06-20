#include <shikken.h>

extern "C" {

SEXP create_gaussian_kernel(SEXP width_, SEXP features_, SEXP cache_size_) {
  Rcpp::NumericVector width(width_);˝
  // TODO: Write a wrapper to convert ShogunFeatures SEXP to a C++ thing
  // ShogunFeatures features(features_);
  Rcpp::NumericVector features(features_);
  Rcpp::NumericVector cache_size(cache_size_);
  
  // There is definietly an "easy" way to convert NumericVector
  // to an ordinary double*
  float64_t* kfeatures = new float64_t[features.size()];
  for (int32_t i = 0; i < features.size(); i++) {
    kfeatures[i] = values[i];
  }
  
  CGaussianKernel* kernel = new CGaussianKernel(cache_size[0], width[0]);
  kernel->init(kfeatures, kfeatures); // kernel->init(features, features);
  
  // TODO: Return an external ptr to kernel
  return R_NilValue;
}

}
