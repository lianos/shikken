#ifndef __SHIKKEN_KMACHINE_H__
#define __SHIKKEN_KMACHINE_H__

#include <shikken.h>

#include <shikken/labels.h>
#include <shikken/features.h>
#include <shikken/kernels.h>

RcppExport SEXP kmachine_set_kernel(SEXP rkmachine, SEXP rkernel);

#endif
