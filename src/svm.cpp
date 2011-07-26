#include "svm.h"

using namespace shogun;

/**
 * Casts the `engine` string to svm_engine_t type
 *
 * It is important that the (with cases) are the same ones that
 * are defined in SVM.R/matchSvmEngine function
 */
svm_engine_t match_svm_engine(std::string engine) {
    svm_engine_t type;
    if (engine.compare("libsvm") == 0) {
        type = LIBSVM;
    } else if (engine.compare("svmlight") == 0) {
        type = SVMLIGHT;
    } else {
        throw std::runtime_error("unknown svm engine");
    }
    return type;
}

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine) {
BEGIN_RCPP
    Rcpp::XPtr<CKernel> kernel(rkernel);
    Rcpp::XPtr<CLabels> labels(rlabels);
    double C = Rcpp::as<double>(rc);
    double epsilon = Rcpp::as<double>(reps);
    svm_engine_t engine = match_svm_engine(Rcpp::as<std::string>(rsvm_engine));
    
    CSVM* svm = NULL;
    
    if (engine == LIBSVM) {
        svm = new CLibSVM(C, kernel, labels);
    } else if (engine == SVMLIGHT) {
        svm = new CSVMLight(C, kernel, labels);
    } else {
        throw std::runtime_error("unknown svm_engine");
        return R_NilValue;
    }
    
    svm->set_epsilon(epsilon);
    SG_REF(svm);
    
    // Rcpp::XPtr<CSVM> out(svm, false);
    // out.setDeleteFinalizer(&_shogun_ref_count_down);
    // return out;
    
    return SG2SEXP(svm);
END_RCPP
}


// TODO: Switch this function to accept the S4 object as rsvm, so we
//       can: (i) get its `engine` label automatically, and (ii) let
//       all *_train function just take 1 argument (the machine), so
//       to enable use of `train.fn` function dispatch from R.
RcppExport SEXP svm_train(SEXP rsvm, SEXP rsvm_engine) {
BEGIN_RCPP
//    S4 svm = S4(rsvm);
    CSVM *svm = static_cast<CSVM*>(R_ExternalPtrAddr(rsvm));
    svm_engine_t engine = match_svm_engine(Rcpp::as<std::string>(rsvm_engine));
    
    if (engine == LIBSVM) {
        CLibSVM* csvm = dynamic_cast<CLibSVM*>(svm);
        csvm->train();
    } else if (engine == SVMLIGHT) {
        CSVMLight* csvm = dynamic_cast<CSVMLight*>(svm);
        csvm->train();
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

