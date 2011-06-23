#include <shikken/svm.h>

using namespace shogun;

RcppExport SEXP svm_init(SEXP rkernel, SEXP rlabels, SEXP rsvm_type,
                         SEXP rcache) {
    Rcpp::XPtr<CKernel> kernel(rkernel);
    Rcpp::XPtr<CLabels> labels(rlabels);
    std::string svm_type = Rcpp::as<std::string>(rsvm_type);
    int cache_size = Rcpp::as<int>(rcache);
    SEXP out;
    
    // TODO: Use an enum type for rsvm_type
    if (svm_type.compare("libsvm") != 0) {
        Rprintf("Unknown svm_type %s\n", svm_type.c_str());
        return R_NilValue;
    }
    
    Rprintf("Building SVM, cache size: %d\n", cache_size);
    CLibSVM* svm = new CLibSVM(cache_size, kernel, labels);
    SG_REF(svm);
    
    Rprintf("Training ... \n");
    svm->train();
    
    SK_WRAP(svm, out);
    return out;
}

RcppExport SEXP svm_train(SEXP rsvm) {
    Rcpp::XPtr<CSVM> svm(rsvm);
    svm->train();
    return R_NilValue;
}

RcppExport SEXP svm_predict(SEXP rsvm, SEXP rfeatures) {
    Rcpp::XPtr<CSVM> svm(rsvm);
    CLabels* preds;
    std::vector<float64_t> out;
    int npreds;
    
    if (rfeatures == R_NilValue) {
        Rprintf("Predicting on training labels\n");
        preds = svm->apply();
    } else {
        Rprintf("Predicting on new data\n");
        Rcpp::XPtr<CFeatures> features(rfeatures);
        preds = svm->apply(features);
    }
    
    Rprintf("Populating output vector\n");
    npreds = preds->get_num_labels();
    for (int i = 0; i < npreds; i++) {
        out.push_back(preds->get_label(i));
    }
    
    return Rcpp::wrap(out);
}
