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

RcppExport SEXP kmachine_support_vectors(SEXP rkmachine);
RcppExport SEXP kmachine_alphas(SEXP rkmachine);
RcppExport SEXP kmachine_get_bias(SEXP rkmachine);

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
