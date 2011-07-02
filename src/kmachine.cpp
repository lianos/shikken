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
