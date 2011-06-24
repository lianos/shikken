#include <shikken/kernels.h>

using namespace shogun;

RcppExport SEXP
create_linear_kernel(SEXP rfeatures) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double cache_size = Rcpp::as<double>(rcache);
    SEXP out;
    
    CLinearKernel* kernel = new CLinearKernel();
    kernel->init(features, features);
    SG_REF(kernel);
    SK_WRAP(kernel, out);
    return out;
}

RcppExport SEXP
create_kernel_gaussian(SEXP rfeatures, SEXP rwidth, SEXP rcache) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double width = Rcpp::as<double>(rwidth);
    double cache_size = Rcpp::as<double>(rcache);
    SEXP out;
    
    CGaussianKernel* kernel = new CGaussianKernel(cache_size, width);
    kernel->init(features, features);
    SG_REF(kernel);
    SK_WRAP(kernel, out);
    return out;
}

RcppExport SEXP
create_kernel_polynomial(SEXP rfeatures, SEXP rdegree, SEXP rinhomo,
                         SEXP rcache) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double degree = Rcpp::as<double>(rwidth);
    bool inhomogeneous = Rcpp::<bool>(rinhomo);
    double cache_size = Rcpp::as<double>(rcache);
    SEXP out;
    
    CPolyKernel* kernel = new CPolyKernel(cache_size, degree, inhomogeneous);
    kernel->init(features, features);
    SG_REF(kernel);
    SK_WRAP(kernel, out);
    return out;
}

RcppExport SEXP
create_sigmoid_kernel(SEXP rfeatures, SEXP rgamma, SEXP rcoef0, SEXP rcache) {
    Rcpp::XPtr<CFeatures> features(rfeatures);
    double gamma = Rcpp::as<double>(rgamma);
    double coef0 = Rcpp::as<double>(rcoef0);
    double cache_size = Rcpp::as<double>(rcache);
    SEXP out;
    
    CSigmoidKernel* kernel = new CSigmoidKernel(cache_size, gamme, coef0);
    kernel->init(features, features);
    SG_REF(kernel);
    SK_WRAP(kernel, out);
    return out;
}

RccpExport SEXP
create_custom_kernel(SEXP rkernel) {
  Rcpp::XPtr<CKernel> features(rkernel);
  return R_NilValue;
}

