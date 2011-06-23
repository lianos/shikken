#ifndef __SHIKKEN_SVM_H__
#define __SHIKKEN_SVM_H__

/////////////////////////////////////////////////////////////////////// Imports
#include <shikken.h>
#include <shikken/labels.h>
#include <shikken/features.h>
#include <shikken/kernels.h>

#include <shogun/classifier/svm/LibSVM.h>

RcppExport SEXP svm_init(SEXP rkernel, SEXP rlabels, SEXP rsvm_type,
                         SEXP rcache);

#endif
