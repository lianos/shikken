#ifndef __SHIKKEN_SVM_H__
#define __SHIKKEN_SVM_H__

/////////////////////////////////////////////////////////////////////// Imports
#include <shikken.h>

#include <shikken/kmachine.h>
#include <shikken/labels.h>
#include <shikken/features.h>
#include <shikken/kernels.h>

#include <classifier/svm/LibSVM.h>
#include <classifier/svm/SVMLight.h>

RcppExport SEXP
svm_init(SEXP rkernel, SEXP rlabels, SEXP rc, SEXP reps, SEXP rsvm_engine);

RcppExport SEXP svm_support_vectors(SEXP rsvm);
RcppExport SEXP svm_alphas(SEXP rsvm);
RcppExport SEXP svm_objective(SEXP rsvm);

RcppExport SEXP svm_predict(SEXP rsvm, SEXP rfeatures);

#endif
