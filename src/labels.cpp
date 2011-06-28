#include <shikken/labels.h>

using namespace shogun;

RcppExport SEXP create_labels(SEXP rlabels) {
    Rcpp::NumericVector labels(rlabels);
    int n = labels.size();
    CLabels* clabels = new CLabels(n);
    SEXP out;
    
    for (int i = 0; i < n; i++) {
        clabels->set_label(i, labels[i]);
    }
    
    SG_REF(clabels);
    SK_WRAP(clabels, out);
    return out;
}
