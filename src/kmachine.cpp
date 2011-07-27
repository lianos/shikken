#include "kmachine.h"

using namespace shogun;

// this should go in a KernelMachine wrapper, since it is defined there
RcppExport SEXP kmachine_set_kernel(SEXP rkmachine, SEXP rkernel) {
BEGIN_RCPP
    Rcpp::XPtr<CKernelMachine> kmachine(rkmachine);
    Rcpp::XPtr<CKernel> kernel(rkernel);
    kmachine->set_kernel(kernel);
    return R_NilValue;
END_RCPP
}

// RcppExport SEXP kmachine_predict(SEXP rkmachine, SEXP rfeatures) {
// BEGIN_RCPP
//     Rcpp::XPtr<CKernelMachine> kmachine(rkmachine);
//     CLabels* preds;
//     std::vector<float64_t> out;
//     int npreds;
//     
//     if (rfeatures == R_NilValue) {
//         // Rprintf("Predicting on training labels\n");
//         preds = kmachine->apply();
//     } else {
//         // Rprintf("Predicting on new data\n");
//         Rcpp::XPtr<CFeatures> features(rfeatures);
//         preds = kmachine->apply(features);
//     }
//     
//     ///////////////////////////////////////////////
//     // This version does not suport subsets
//     // -------------------------------------------
//     // float64_t *slabels;
//     // int32_t slen;
//     // slabels = preds->get_labels(slen);
//     // for (int i = 0; i < slen; i++) {
//     //     out.push_back(slabels[i]);
//     // }
//     
//     npreds = preds->get_num_labels();
//     for (int i = 0; i < npreds; i++) {
//         out.push_back(preds->get_label(i));
//     }
//     
//     return Rcpp::wrap(out);
// END_RCPP
// }

RcppExport SEXP kmachine_predict(SEXP rkmachine, SEXP rfeatures) {
BEGIN_RCPP
    shikken::KernelMachine km(rkmachine);
    SEXP out;
    if (rfeatures == R_NilValue) {
        out = km.predict();
    } else {
        out = km.predict_on(rfeatures);
    }
    return out;
END_RCPP
}

/**
 * Returns the C-indices of the support vectors
 */
RcppExport SEXP kmachine_support_vectors(SEXP rkmachine) {
    Rcpp::XPtr<CKernelMachine> kmachine(rkmachine);
    int nsv = kmachine->get_num_support_vectors();
    std::vector<int32_t> sv;
    
    for (int i = 0; i < nsv; i++) {
        sv.push_back(kmachine->get_support_vector(i));
    }
    
    return Rcpp::wrap(sv);
}

/**
 * Returns the alphas
 */
RcppExport SEXP kmachine_alphas(SEXP rkmachine) {
    Rcpp::XPtr<CKernelMachine> kmachine(rkmachine);
    int nsv = kmachine->get_num_support_vectors();
    std::vector<float64_t> alpha;
    
    for (int i = 0; i < nsv; i++) {
        alpha.push_back(kmachine->get_alpha(i));
    }
    
    return Rcpp::wrap(alpha);
}

/** Returns the bias */
RcppExport SEXP kmachine_bias(SEXP rkmachine) {
    Rcpp::XPtr<CKernelMachine> kmachine(rkmachine);
    return Rcpp::wrap(kmachine->get_bias());
}
