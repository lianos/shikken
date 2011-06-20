#ifndef __SHIKKEN_KERNELS_H__
#define __SHIKKEN_KERNELS_H__

#include <shogun/kernel/GaussianKernel.h>

extern "C" {
  SEXP create_gaussian_kernel(SEXP width_, SEXP cache_size_);
}

#endif
