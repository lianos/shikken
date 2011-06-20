#ifndef __SHIKKEN_FEATURES_H__
#define __SHIKKEN_FEATURES_H__

#include <shogun/features/SimpleFeatures.h>

extern "C" {
  SEXP create_simple_features(SEXP data_, SEXP dims_);
}

#endif
