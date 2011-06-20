#include <shikken/kernels.h>

using namespace shogun;

RcppExport SEXP create_gaussian_kernel(SEXP features_, SEXP width_,
                                       SEXP cache_size_) {
BEGIN_RCPP
    // Rcpp::NumericVector features(features_);
    // Rcpp::NumericVector w(width_);
    // Rcpp::NumericVector cs(cache_size_);
    Rcpp::XPtr<CFeatures> fptr(features_);
    double width = Rcpp::as<double>(width_);
    double cache_size = Rcpp::as<double>(cache_size_);
    
    // CGaussianKernel* kernel = new CGaussianKernel(cache_size[0], width[0]);
    CGaussianKernel* kernel = new CGaussianKernel(cache_size, width);
    kernel->init(fptr, fptr); // kernel->init(features, features);
    SG_REF(kernel);
    
    Rcpp::XPtr<CDotKernel> ptr(kernel);
    return ptr;
END_RCPP
}

