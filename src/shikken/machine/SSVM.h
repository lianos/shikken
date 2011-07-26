#ifndef __SHIKKEN_SSVM_H__
#define __SHIKKEN_SSVM_H__

#include <shogun/classifier/svm/LibSVM.h>
#include <shogun/classifier/svm/SVMLight.h>

#include <Rcpp.h>

#include "shikken/base/ShikkenObject.h"

namespace shikken {

enum svm_engine_t {LIBSVM=1, SVMLIGHT};

class SVM : public ShikkenObject {
public:
    SVM(SEXP rsvm);
    virtual void train();
    
private:
    SEXP rsvm;
    Rcpp::S4 svm;
    shogun::CSVM* csvm;
    svm_engine_t engine;
};

}

#endif

