#ifndef __SHIKKEN_SVM_H__
#define __SHIKKEN_SVM_H__

/////////////////////////////////////////////////////////////////////// Imports
#include <shogun/classifier/svm/LibSVM.h>
#include <shogun/classifier/svm/SVMLight.h>

#include "shikken/base/common.h"
#include "shikken/machine/SSVM.h"

#include "kmachine.h"
#include "labels.h"
#include "features.h"
#include "kernels.h"




///////////////////////////////////////////////////////////////////////////////

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine);

//RcppExport SEXP svm_train(SEXP rsvm, SEXP rsvm_engine);
RcppExport SEXP svm_train(SEXP rsvm);

RcppExport SEXP svm_objective(SEXP rsvm);

#endif
