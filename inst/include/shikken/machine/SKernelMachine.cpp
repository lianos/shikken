#include "shikken/machine/SKernelMachine.h"

using namespace shikken;

KernelMachine::KernelMachine(SEXP rkmachine) : 
ShikkenObject(rkmachine) {
    this->ckm = static_cast<shogun::CKernelMachine*>(this->sg_ptr());
}

KernelMachine::~KernelMachine() {
    // TODO: delete?
    this->ckm = NULL;
}

void KernelMachine::train() {
    
}

SEXP KernelMachine::predict() {
    // shogun::CLabels* preds = this->;
    // std::vector<float64_t> out;
    return R_NilValue;
}

SEXP KernelMachine::predict(SEXP rfeatures) {
    // shogun::CLabels* preds;
    // std::vector<float64_t> out;
    return R_NilValue;
}
