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
    SEXP out;

    // NOTE: There msut be an easy way to extract the double* ptr from
    //       Rcpp::NumericVector without doing the copying below
    //       It's probably: float64_t* data.get_ref();
    // float64_t* matrix = REAL(data.get_ref()); // why not?
    float64_t* matrix = new float64_t[data.size()];
    for (int32_t i = 0; i < data.size(); i++) {
        matrix[i] = (float64_t) data[i];
    }
    
    CSimpleFeatures<float64_t>* features = new CSimpleFeatures<float64_t>();
    features->set_feature_matrix(matrix, dim, nobs);

    SG_REF(features);

    SK_WRAP(features, out);
    return out;
END_RCPP
}

RcppExport SEXP
features_create_simple_sparse(SEXP rdata, SEXP rnobs, SEXP rdim) {
BEGIN_RCPP
    return R_NilValue;
END_RCPP
}
