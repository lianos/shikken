#ifndef __SHIKKEN_SVM_H__
#define __SHIKKEN_SVM_H__

/////////////////////////////////////////////////////////////////////// Imports
#include "shikken.h"

#include "kmachine.h"
#include "labels.h"
#include "features.h"
#include "kernels.h"

#include <shogun/classifier/svm/LibSVM.h>
#include <shogun/classifier/svm/SVMLight.h>

#include <shikken/machine/SSVM.h>

///////////////////////////////////////////////////////////////////////////////

// 1-for-1 match with R/SVM.R
// enum svm_engine_t {LIBSVM=1, SVMLIGHT};
// shikken::svm_engine_t match_svm_engine(std::string engine);

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine);

//RcppExport SEXP svm_train(SEXP rsvm, SEXP rsvm_engine);
RcppExport SEXP svm_train(SEXP rsvm);

RcppExport SEXP svm_objective(SEXP rsvm);

#endif
