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

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine);

RcppExport SEXP svm_support_vectors(SEXP rsvm);
RcppExport SEXP svm_alphas(SEXP rsvm);
RcppExport SEXP svm_objective(SEXP rsvm);

RcppExport SEXP svm_predict(SEXP rsvm, SEXP rfeatures);

#endif
