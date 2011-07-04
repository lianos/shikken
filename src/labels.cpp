#include "labels.h"

using namespace shogun;

RcppExport SEXP labels_create(SEXP rlabels) {
    Rcpp::NumericVector labels(rlabels);
    int n = labels.size();
    CLabels* clabels = new CLabels(n);
    SEXP out;
    
    for (int i = 0; i < n; i++) {
        clabels->set_label(i, labels[i]);
    }
    
    SG_REF(clabels);
    return SG2SEXP(clabels);
}

RcppExport SEXP labels_length(SEXP rlabels) {
    Rcpp::XPtr<CLabels> labels(rlabels);
    return Rcpp::wrap(labels->get_num_labels());
}

RcppExport SEXP labels_get(SEXP rlabels) {
    Rcpp::XPtr<CLabels> labels(rlabels);
    int num = labels->get_num_labels();
    std::vector<float64_t> out;
    for (int i = 0; i < num; i++) {
        out.push_back(labels->get_label(i));
    }
    return Rcpp::wrap(out);
}