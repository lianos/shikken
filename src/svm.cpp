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


RcppExport SEXP svm_train(SEXP rsvm, SEXP rsvm_engine) {
BEGIN_RCPP
    CSVM * svm = (CSVM *) R_ExternalPtrAddr(rsvm);
    // Rcpp::XPtr<CSVM> xx(rsvm);
    // CSVM * svm = xx&;
    std::string svm_engine = Rcpp::as<std::string>(rsvm_engine);
    
    if (svm_engine.compare("libsvm") == 0) {
        DCAST((svm), CLibSVM, train);
    } else if (svm_engine.compare("svmlight" == 0)) {
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

RcppExport SEXP svm_predict(SEXP rsvm, SEXP rfeatures) {
BEGIN_RCPP
    Rcpp::XPtr<CSVM> svm(rsvm);
    CLabels* preds;
    std::vector<float64_t> out;
    int npreds;
    float64_t *slabels;
    int32_t slen;
    
    if (rfeatures == R_NilValue) {
        // Rprintf("Predicting on training labels\n");
        preds = svm->apply();
    } else {
        // Rprintf("Predicting on new data\n");
        Rcpp::XPtr<CFeatures> features(rfeatures);
        preds = svm->apply(features);
    }
    
    ///////////////////////////////////////////////
    // This version does not suport subsets
    // slabels = preds->get_labels(slen);
    // for (int i = 0; i < slen; i++) {
    //     out.push_back(slabels[i]);
    // }
    
    npreds = preds->get_num_labels();
    for (int i = 0; i < npreds; i++) {
        out.push_back(preds->get_label(i));
    }
    
    return Rcpp::wrap(out);
END_RCPP
}

/**
 * Returns the C-indices of the support vectors
 */
// RcppExport SEXP svm_support_vectors(SEXP rsvm) {
//     Rcpp::XPtr<CSVM> svm(rsvm);
//     int nsv = svm->get_num_support_vectors();
//     std::vector<int32_t> sv;
//     
//     for (int i = 0; i < nsv; i++) {
//         sv.push_back(svm->get_support_vector(i));
//     }
//     
//     return Rcpp::wrap(sv);
// }

/**
 * Returns the alphas
 */
// RcppExport SEXP svm_alphas(SEXP rsvm) {
//     Rcpp::XPtr<CSVM> svm(rsvm);
//     int nsv = svm->get_num_support_vectors();
//     std::vector<float64_t> alpha;
//     
//     for (int i = 0; i < nsv; i++) {
//         alpha.push_back(svm->get_alpha(i));
//     }
//     
//     return Rcpp::wrap(alpha);
// }

/** Returns the bias */
// RcppExport SEXP svm_bias(SEXP rsvm) {
//     Rcpp::XPtr<CSVM> svm(rsvm);
//     return Rcpp::wrap(svm->get_bias());
// }
