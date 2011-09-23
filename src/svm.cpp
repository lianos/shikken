#include "svm.h"

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine) {
BEGIN_RCPP
    Rcpp::XPtr<shogun::CKernel> kernel(rkernel);
    Rcpp::XPtr<shogun::CLabels> labels(rlabels);
    double C = Rcpp::as<double>(rc);
    double epsilon = Rcpp::as<double>(reps);
    
    shikken::svm_engine_t engine = shikken::SVM::match_svm_engine(Rcpp::as<std::string>(rsvm_engine));
    
    shogun::CSVM* svm = NULL;
    
    if (engine == shikken::LIBSVM) {
        svm = new shogun::CLibSVM(C, kernel, labels);
    } else if (engine == shikken::SVMLIGHT) {
        svm = new shogun::CSVMLight(C, kernel, labels);
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

RcppExport SEXP svm_train(SEXP rsvm) {
BEGIN_RCPP
    shikken::SVM svm(rsvm);
    svm.train();
    return R_NilValue;
END_RCPP
}

RcppExport SEXP svm_objective(SEXP rsvm) {
    Rcpp::XPtr<shogun::CSVM> svm(rsvm);
    return Rcpp::wrap(svm->get_objective());
}

