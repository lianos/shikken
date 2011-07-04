#include "svm.h"

using namespace shogun;

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine) {
BEGIN_RCPP
    Rcpp::XPtr<CKernel> kernel(rkernel);
    Rcpp::XPtr<CLabels> labels(rlabels);
    double C = Rcpp::as<double>(rc);
    double epsilon = Rcpp::as<double>(reps);
    
    std::string svm_engine = Rcpp::as<std::string>(rsvm_engine);
    CSVM* svm = NULL;
    
    // SEXP out;
    SEXP sg_ptr;
    
    if (svm_engine.compare("libsvm") == 0) {
        CLibSVM* csvm = new CLibSVM(C, kernel, labels);
        //// Rprintf("Training libsvm ... \n");
        //csvm->train();
        svm = csvm;
    } else if (svm_engine.compare("svmlight") == 0) {
        CSVMLight* csvm = new CSVMLight(C, kernel, labels);
        // Rprintf("Training svmlight ... \n");
        // csvm->set_epsilon(epsilon);
        // csvm->train();
        svm = csvm;
    } else {
        // Rprintf("Unsupported svm_engine %s\n", svm_engine.c_str());
        std::runtime_error("unknown svm_engine");
        return R_NilValue;
    }
    // Rprintf("... training done\n");
    svm->set_epsilon(epsilon);
    SG_REF(svm);
    // return Rcpp::wrap(svm);
    // out = Rcpp::List::create(Rcpp::Named("sg.ptr", sg_ptr),
    //                          Rcpp::Named("alpha", ))
    
    // SK_WRAP(svm, sg_ptr);
    return SG2SEXP(svm);
END_RCPP
}


// TODO: Switch this function to accept the S4 object as rsvm, so we
//       can: (i) get its `engine` label automatically, and (ii) let
//       all *_train function just take 1 argument (the machine), so
//       to enable use of `train.fn` function dispatch from R.
RcppExport SEXP svm_train(SEXP rsvm, SEXP rsvm_engine) {
BEGIN_RCPP
    CSVM *svm = static_cast<CSVM*>(R_ExternalPtrAddr(rsvm));
    std::string svm_engine = Rcpp::as<std::string>(rsvm_engine);
    
    if (svm_engine.compare("libsvm") == 0) {
        DCAST((svm), CLibSVM, train);
    } else if (svm_engine.compare("svmlight") == 0) {
        DCAST((svm), CSVMLight, train);
    } else {
        std::runtime_error("unknown svm_engine");
    }
    
    return R_NilValue;
END_RCPP
}

RcppExport SEXP svm_objective(SEXP rsvm) {
    Rcpp::XPtr<CSVM> svm(rsvm);
    return Rcpp::wrap(svm->get_objective());
}

