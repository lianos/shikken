#ifndef __SHIKKEN_KMACHINE_H__
#define __SHIKKEN_KMACHINE_H__

#include "shikken.h"

#include "labels.h"
#include "features.h"
#include "kernels.h"

RcppExport SEXP kmachine_set_kernel(SEXP rkmachine, SEXP rkernel);

#endif
