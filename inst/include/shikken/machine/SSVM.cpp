#include "shikken/machine/SSVM.h"

using namespace shikken;

svm_engine_t SVM::match_svm_engine(std::string engine) {
    svm_engine_t type;
    if (engine.compare("libsvm") == 0) {
        type = LIBSVM;
    } else if (engine.compare("svmlight") == 0) {
        type = SVMLIGHT;
    } else {
        throw ShikkenException("unknown svm engine");
    }
    return type;
}

// static SVM* SVM::init()
SVM::SVM(SEXP rsvm) : KernelMachine(rsvm) {
    std::string e = Rcpp::as<std::string>(s4->slot("engine"));
    this->engine = SVM::match_svm_engine(e);
    this->csvm = static_cast<shogun::CSVM*>(this->ckm);
}

SVM::~SVM() {
    // TODO: delete?
    this->csvm = NULL;
}

void SVM::train() {
    if (engine == LIBSVM) {
        shogun::CLibSVM* tsvm = dynamic_cast<shogun::CLibSVM*>(csvm);
        tsvm->train();
    } else if (engine == SVMLIGHT) {
        shogun::CSVMLight* tsvm = dynamic_cast<shogun::CSVMLight*>(csvm);
        tsvm->train();
    } else {
        // this should never happen
        throw ShikkenException("Unknown SVM Engine");
    }
}
