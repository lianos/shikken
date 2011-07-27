#ifndef __SHIKKEN_SSVM_H__
#define __SHIKKEN_SSVM_H__

#include <shogun/classifier/svm/LibSVM.h>
#include <shogun/classifier/svm/SVMLight.h>

#include <Rcpp.h>

#include "shikken/base/ShikkenException.h"
#include "shikken/machine/SKernelMachine.h"

namespace shikken {

enum svm_engine_t { LIBSVM=1, SVMLIGHT };

class SVM : public KernelMachine {
public:
    
    static svm_engine_t match_svm_engine(std::string engine);
    
    SVM(SEXP rsvm);
    virtual ~SVM();
    
    virtual void train();
    
protected:
    shogun::CSVM* csvm;
    svm_engine_t engine;
};

}

#endif

