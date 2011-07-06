#include "kernels.h"

using namespace shogun;

RcppExport SEXP
create_kernel_linear(SEXP rfeatures) {
BEGIN_RCPP
    Rcpp::XPtr<CFeatures> features(rfeatures);
    
    CLinearKernel* kernel = new CLinearKernel();
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
END_RCPP
}

RcppExport SEXP
create_kernel_gaussian(SEXP rfeatures, SEXP rwidth, SEXP rcache) {
BEGIN_RCPP
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double width = Rcpp::as<double>(rwidth);
    double cache_size = Rcpp::as<double>(rcache);
    
    CGaussianKernel* kernel = new CGaussianKernel(cache_size, width);
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
END_RCPP
}

RcppExport SEXP
create_kernel_polynomial(SEXP rfeatures, SEXP rdegree, SEXP rinhomo,
                         SEXP rcache) {
BEGIN_RCPP
    Rcpp::XPtr<CPolyFeatures> features(rfeatures);
    double degree = Rcpp::as<double>(rdegree);
    bool inhomogeneous = Rcpp::as<bool>(rinhomo);
    double cache_size = Rcpp::as<double>(rcache);
    
    CPolyKernel* kernel = new CPolyKernel(cache_size, degree, inhomogeneous);
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
END_RCPP
}

RcppExprt SEXP poly_kernel_degree(SEXP rkernel) {
    
}
RcppExprt SEXP poly_kernel_inhomogeneous(SEXP rkernel) {
    
}


RcppExport SEXP
create_kernel_sigmoid(SEXP rfeatures, SEXP rgamma, SEXP rcoef0, SEXP rcache) {
BEGIN_RCPP
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double gamma = Rcpp::as<double>(rgamma);
    double coef0 = Rcpp::as<double>(rcoef0);
    double cache_size = Rcpp::as<double>(rcache);
    
    CSigmoidKernel* kernel = new CSigmoidKernel(cache_size, gamma, coef0);
    kernel->init(features, features);
    SG_REF(kernel);
    return SG2SEXP(kernel);
END_RCPP
}

RcppExport SEXP
create_kernel_custom(SEXP rkernel) {
BEGIN_RCPP
    Rcpp::XPtr<CKernel> features(rkernel);
    return R_NilValue;
END_RCPP
}

