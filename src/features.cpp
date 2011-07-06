#include "features.h"

using namespace shogun;

RcppExport SEXP features_length(SEXP rfeatures) {
    Rcpp::XPtr<CLabels> features(rfeatures);
    
}


CSimpleFeatures<float64_t>*
_features_create_simple_dense(SEXP rdata, SEXP rnobs, SEXP rdim) {
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
    return features;
}

CSparseFeatures<float64_t>*
_features_create_simple_sparse(SEXP rdata, SEXP rnobs, SEXP rdim) {
    throw std::runtime_error("Sparse simple features not implemented yet.");
    return NULL;
}

// shogun features are stored in column order, where each column denotes
// a feature vector for an example
// columns are linear in memory
//
// ->set_feature_matrix(matrix, n.dimensions, n.observations)
RcppExport SEXP
features_create_simple_dense(SEXP rdata, SEXP rnobs, SEXP rdim) {
BEGIN_RCPP
    CSimpleFeatures<float64_t>* features = _features_create_simple_dense(rdata, rnobs, rdim);
    return SG2SEXP(features);
END_RCPP
}

RcppExport SEXP
features_create_simple_sparse(SEXP rdata, SEXP rnobs, SEXP rdim) {
BEGIN_RCPP
    return R_NilValue;
END_RCPP
}

RcppExport SEXP
features_create_poly_dense(SEXP rdata, SEXP rnobs, SEXP rdim, SEXP rdegree, SEXP rnormalize) {
BEGIN_RCPP
    int degree = Rcpp::as<int>(rdegree);
    bool normalize = Rcpp::as<bool>(rnormalize);
    CSimpleFeatures<float64_t>* simple = _features_create_simple_dense(rdata, rnobs, rdim);
    CPolyFeatures* pfeatures = new CPolyFeatures(simple, degree, normalize);
    SG_REF(pfeatures);
    return SG2SEXP(pfeatures);
END_RCPP
}

RcppExport SEXP
features_create_poly_sparse(SEXP rdata, SEXP rnobs, SEXP rdim, SEXP rdegree, SEXP rnormalize,
                            SEXP rhash_bits) {
BEGIN_RCPP
    int degree = Rcpp::as<int>(rdegree);
    bool normalize = Rcpp::as<bool>(rnormalize);
    int hash_bits = Rcpp::as<int>(rhash_bits);
    CSparseFeatures<float64_t>* simple = _features_create_simple_sparse(rdata, rnobs, rdim);
    CSparsePolyFeatures* pfeatures = new CSparsePolyFeatures(simple, degree, normalize, hash_bits);
    SG_REF(pfeatures);
    return SG2SEXP(pfeatures);
END_RCPP
}

