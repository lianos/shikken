// #include <shikken/svm.h>
#include <shikken.h>

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
    
    SEXP out;
    
    if (svm_engine.compare("libsvm") == 0) {
        CLibSVM* csvm = new CLibSVM(C, kernel, labels);
        csvm->set_epsilon(epsilon);
        // Rprintf("Training libsvm ... \n");
        csvm->train();
        svm = csvm;
    } else if (svm_engine.compare("svmlight") == 0) {
        CSVMLight* csvm = new CSVMLight(C, kernel, labels);
        // Rprintf("Training svmlight ... \n");
        csvm->set_epsilon(epsilon);
        csvm->train();
        svm = csvm;
    } else {
        // Rprintf("Unsupported svm_engine %s\n", svm_engine.c_str());
        return R_NilValue;
    }
    // Rprintf("... training done\n");
    SG_REF(svm);
    SK_WRAP(svm, out);
    return out;
END_RCPP
}

// RcppExport SEXP svm_train(SEXP rsvm) {
//     Rcpp::XPtr<CSVM> svm(rsvm);
//     svm->train();
//     return R_NilValue;
// }

// returns the indices of the support vectors
RcppExport SEXP svm_support_vectors(SEXP rsvm) {
    Rcpp::XPtr<CSVM> svm(rsvm);
    int nsv = svm->get_num_support_vectors();
    std::vector<int32_t> sv;
    
    for (int i = 0; i < nsv; i++) {
        sv.push_back(svm->get_support_vector(i));
    }
    
    return Rcpp::wrap(sv);
}

// returns the alphas
RcppExport SEXP svm_alphas(SEXP rsvm) {
    Rcpp::XPtr<CSVM> svm(rsvm);
    int nsv = svm->get_num_support_vectors();
    std::vector<float64_t> alpha;
    
    for (int i = 0; i < nsv; i++) {
        alpha.push_back(svm->get_alpha(i));
    }
    
    return Rcpp::wrap(alpha);
}


RcppExport SEXP svm_predict(SEXP rsvm, SEXP rfeatures) {
    Rcpp::XPtr<CSVM> svm(rsvm);
    CLabels* preds;
    std::vector<float64_t> out;
    int npreds;
    
    if (rfeatures == R_NilValue) {
        // Rprintf("Predicting on training labels\n");
        preds = svm->apply();
    } else {
        // Rprintf("Predicting on new data\n");
        Rcpp::XPtr<CFeatures> features(rfeatures);
        preds = svm->apply(features);
    }
    
    // Rprintf("Populating output vector\n");
    npreds = preds->get_num_labels();
    for (int i = 0; i < npreds; i++) {
        out.push_back(preds->get_label(i));
    }
    
    return Rcpp::wrap(out);
}
