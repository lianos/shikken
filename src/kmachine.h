#ifndef __SHIKKEN_KMACHINE_H__
#define __SHIKKEN_KMACHINE_H__

#include "shikken.h"

#include "labels.h"
#include "features.h"
#include "kernels.h"

#include <shogun/machine/KernelMachine.h>
#include "shikken/machine/SKernelMachine.h"

RcppExport SEXP kmachine_set_kernel(SEXP rkmachine, SEXP rkernel);
RcppExport SEXP kmachine_predict(SEXP rkmachine, SEXP rfeatures);
RcppExport SEXP kmachine_support_vectors(SEXP rkmachine);
RcppExport SEXP kmachine_alphas(SEXP rkmachine);
RcppExport SEXP kmachine_bias(SEXP rkmachine);

#endif
