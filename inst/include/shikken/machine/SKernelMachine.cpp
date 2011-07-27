#include "Rcpp.h"

#include <shogun/features/Labels.h>

#include "shikken/base/ShikkenException.h"
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
    throw ShikkenException("Subclasses must implement train()");
}

SEXP KernelMachine::predict() {
    shogun::CLabels* preds = this->ckm->apply();
    int npreds = preds->get_num_labels();
    std::vector<float64_t> out;
    
    for (int i = 0; i < npreds; i++) {
        out.push_back(preds->get_label(i));
    }
    
    return Rcpp::wrap(out);
}

SEXP KernelMachine::predict_on(SEXP rfeatures) {
    Rcpp::XPtr<shogun::CFeatures> features(rfeatures);
    shogun::CLabels* preds = this->ckm->apply(features);
    int npreds = preds->get_num_labels();
    std::vector<float64_t> out;
    
    for (int i = 0; i < npreds; i++) {
        out.push_back(preds->get_label(i));
    }
    
    return Rcpp::wrap(out);
}
