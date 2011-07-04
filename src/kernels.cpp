#include "kernels.h"

using namespace shogun;

RcppExport SEXP
create_kernel_linear(SEXP rfeatures) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    
    CLinearKernel* kernel = new CLinearKernel();
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
}

RcppExport SEXP
create_kernel_gaussian(SEXP rfeatures, SEXP rwidth, SEXP rcache) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double width = Rcpp::as<double>(rwidth);
    double cache_size = Rcpp::as<double>(rcache);
    
    CGaussianKernel* kernel = new CGaussianKernel(cache_size, width);
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
}

RcppExport SEXP
create_kernel_polynomial(SEXP rfeatures, SEXP rdegree, SEXP rinhomo,
                         SEXP rcache) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double degree = Rcpp::as<double>(rdegree);
    bool inhomogeneous = Rcpp::as<bool>(rinhomo);
    double cache_size = Rcpp::as<double>(rcache);
    
    CPolyKernel* kernel = new CPolyKernel(cache_size, degree, inhomogeneous);
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
}

RcppExport SEXP
create_kernel_sigmoid(SEXP rfeatures, SEXP rgamma, SEXP rcoef0, SEXP rcache) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double gamma = Rcpp::as<double>(rgamma);
    double coef0 = Rcpp::as<double>(rcoef0);
    double cache_size = Rcpp::as<double>(rcache);
    
    CSigmoidKernel* kernel = new CSigmoidKernel(cache_size, gamma, coef0);
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
}

RcppExport SEXP
create_kernel_custom(SEXP rkernel) {
  Rcpp::XPtr<CKernel> features(rkernel);
  return R_NilValue;
}

