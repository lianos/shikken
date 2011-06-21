#ifndef __SHIKKEN_KERNELS_H__
#define __SHIKKEN_KERNELS_H__

/////////////////////////////////////////////////////////////////////// Imports
#include <shikken.h>

#include <shogun/kernel/CustomKernel.h>
#include <shogun/kernel/GaussianKernel.h>
#include <shogun/kernel/LinearKernel.h>
#include <shogun/kernel/PolyKernel.h>
#include <shogun/kernel/StringKernel.h>

#include <shogun/kernel/SparseKernel.h>


//////////////////////////////////////////////////////////////// Implementation

// Subclasses of CDotKernel
//   - GaussianKernel
//   - PolyKernel
//   - LinearKernel
//   - Chi2Kernel
//   - WaveletKerneL
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
// String kernels subclass CKernel

RcppExport SEXP create_gaussian_kernel(SEXP features, SEXP width_,
                                       SEXP cache_size_);

#endif
