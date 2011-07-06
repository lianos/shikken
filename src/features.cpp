#include "features.h"

using namespace shogun;

RcppExport SEXP features_length(SEXP rfeatures) {
    Rcpp::XPtr<CLabels> features(rfeatures);
    
}

// shogun features are stored in column order, where each column denotes
// a feature vector for an example
// columns are linear in memory
//
// ->set_feature_matrix(matrix, n.dimensions, n.observations)
RcppExport SEXP
features_create_simple_dense(SEXP rdata, SEXP rnobs, SEXP rdim) {
BEGIN_RCPP
    Rcpp::NumericVector data(rdata);
    int nobs = Rcpp::as<int>(rnobs);
    int dim = Rcpp::as<int>(rdim);
    
    // NOTE: There msut be an easy way to extract the double* ptr from
    //       Rcpp::NumericVector without doing the copying below
    //       It's probably: float64_t* data.get_ref();
    // float64_t* matrix = REAL(data.get_ref()); // why not?
    float64_t* matrix = new float64_t[data.size()];
    for (int32_t i = 0; i < data.size(); i++) {
        matrix[i] = (float64_t) data[i];
    }
    
    // Rcpp::XPtr< CSimpleFeatures<float64_t> > \
    //     features(new CSimpleFeatures<float64_t>(), true);
    // feaatures->ref();
    CSimpleFeatures<float64_t>* features = new CSimpleFeatures<float64_t>();
    features->set_feature_matrix(matrix, dim, nobs);
    SG_REF(features);
    return SG2SEXP(features);
END_RCPP
}

RcppExport SEXP
features_create_simple_sparse(SEXP rdata, SEXP rnobs, SEXP rdim) {
BEGIN_RCPP
    throw std::runtime_error("Sparse simple features not implemented yet.");
    return R_NilValue;
END_RCPP
}


RcppExport SEXP
features_create_poly_dense(SEXP rdata, SEXP rnobs, SEXP rdim, SEXP rdegree, SEXP rnormalize) {
BEGIN_RCPP
    // these are built from a 'simple features' object -- code is duplicated
    // because of the whole memory counting/SEXP wrapping thing in
    // features_create_simple_dense
    Rcpp::NumericVector data(rdata);
    int nobs = Rcpp::as<int>(rnobs);
    int dim = Rcpp::as<int>(rdim);
    int degree = Rcpp::as<int>(rdegree);
    bool normalize = Rcpp::as<bool>(rnormalize);
    
    float64_t* matrix = new float64_t[data.size()];
    for (int32_t i = 0; i < data.size(); i++) {
        matrix[i] = (float64_t) data[i];
    }
    
    CSimpleFeatures<float64_t>* features = new CSimpleFeatures<float64_t>();
    features->set_feature_matrix(matrix, dim, nobs);
    CPolyFeatures* pfeatures = new CPolyFeatures(features, degree, normalize);
    SG_REF(pfeatures);
    
    return SG2SEXP(pfeatures);
END_RCPP
}

RcppExport SEXP
features_create_poly_sparse(SEXP rdata, SEXP rnobs, SEXP rdim, SEXP degree, SEXP normalize) {
BEGIN_RCPP
    throw std::runtime_error("Sparse poly features not implemented yet.");
    return R_NilValue;
END_RCPP
}
