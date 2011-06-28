#ifndef __SHIKKEN_KERNELS_H__
#define __SHIKKEN_KERNELS_H__

/////////////////////////////////////////////////////////////////////// Imports
#include <shikken.h>

#include <kernel/Kernel.h>
#include <kernel/GaussianKernel.h>
#include <kernel/LinearKernel.h>
#include <kernel/PolyKernel.h>
#include <kernel/SigmoidKernel.h>

#include <kernel/StringKernel.h>
#include <kernel/CustomKernel.h>

#include <kernel/SparseKernel.h>


//////////////////////////////////////////////////////////////// Implementation

// Subclasses of CDotKernel
//   - GaussianKernel
//   - PolyKernel
//   - LinearKernel
//   - Chi2Kernel
//   - WaveletKerneL
//   - SigmoidKernel
//
// Sublcasses of CKernel
//   - RationalQuadritKernel
//   - StringKernel (and all its subclasses)
//   - PowerKernel
//   - DistanceKernel
//   - CombinedKernel
//   - CauchyKernel
//   - TStudentKernel
//   - WaveKernel
//   - CustomKernel
// String kernels subclass CKernel

RcppExport SEXP
create_kernel_linear(SEXP rfeatures);

RcppExport SEXP
create_kernel_gaussian(SEXP rfeatures, SEXP rwidth, SEXP rcache);

RcppExport SEXP
create_kernel_polynomial(SEXP rfeatures, SEXP rdegree, SEXP rinhomo,
                         SEXP rcache);

RcppExport SEXP
create_kernel_sigmoid(SEXP rfeatures, SEXP rgamma, SEXP rcoef0, SEXP rcache);

RcppExport SEXP
create_kernel_custom(SEXP rkernel);

#endif
