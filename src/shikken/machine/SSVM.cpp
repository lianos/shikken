#include "shikken/machine/SSVM.h"

using namespace shikken;

SVM::SVM(SEXP rsvm) : ShikkenObject(rsvm) {
    Rcpp::S4 svm = Rcpp::S4(rsvm);
    // TODO: Check S4 inheritance from class attribute
    // TODO: Match engine 
    // std::string engine_ = Rcpp::as<std::string>(svm.slot("engine"));
    // this->engine = match_svm_engine(engine_);
    this->csvm = static_cast<shogun::CSVM*>(R_ExternalPtrAddr(SEXP(svm.slot("sg.ptr"))));
}

void SVM::train() {
//     CSVM *svm = static_cast<CSVM*>(R_ExternalPtrAddr(rsvm));
//     svm_engine_t engine = match_svm_engine(Rcpp::as<std::string>(rsvm_engine));
//     
//     if (engine == LIBSVM) {
//         CLibSVM* csvm = dynamic_cast<CLibSVM*>(svm);
//         csvm->train();
//     } else if (engine == SVMLIGHT) {
//         CSVMLight* csvm = dynamic_cast<CSVMLight*>(svm);
//         csvm->train();
//     } else {
//         std::runtime_error("unknown svm_engine");
//     }    
}