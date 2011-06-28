#ifndef __SHIKKEN_FEATURES_H__
#define __SHIKKEN_FEATURES_H__

/////////////////////////////////////////////////////////////////////// Imports
#include "shikken.h"

#include <features/Labels.h>

// dense feature matrices
//  SimpleFeatures extends DotFeatures extends Features
#include <features/SimpleFeatures.h>

// StringFeatures extend Features
#include <features/StringFeatures.h>
// StringFeatures that are file based through Memory-mapped files.
#include <features/StringFileFeatures.h>

// dotfeatures for polyhnomial kernel
#include <features/PolyFeatures.h>

// CombinedFeatures extend Features
#include <features/CombinedFeatures.h>
// extend DotFeatures
#include <features/CombinedDotFeatures.h>

// SparseFeatures extends DotFeatures extends Features
#include <features/SparseFeatures.h>
#include <features/SparsePolyFeatures.h>

///////////////////////////////////////////////////////////////////// interface
RcppExport SEXP
create_simple_features_dense(SEXP rdata, SEXP rnobs, SEXP rdim);

RcppExport SEXP
create_simple_features_sparse(SEXP rdata, SEXP rnobs, SEXP rdim);
#endif
