#ifndef __SHIKKEN_FEATURES_H__
#define __SHIKKEN_FEATURES_H__

/////////////////////////////////////////////////////////////////////// Imports
#include "shikken.h"

#include <shogun/features/Labels.h>

// dense feature matrices
//  SimpleFeatures extends DotFeatures extends Features
#include <shogun/features/SimpleFeatures.h>

// StringFeatures extend Features
#include <shogun/features/StringFeatures.h>
// StringFeatures that are file based through Memory-mapped files.
#include <shogun/features/StringFileFeatures.h>

// dotfeatures for polyhnomial kernel
#include <shogun/features/PolyFeatures.h>

// CombinedFeatures extend Features
#include <shogun/features/CombinedFeatures.h>
// extend DotFeatures
#include <shogun/features/CombinedDotFeatures.h>

// SparseFeatures extends DotFeatures extends Features
#include <shogun/features/SparseFeatures.h>
#include <shogun/features/SparsePolyFeatures.h>

///////////////////////////////////////////////////////////////////// interface
RcppExport SEXP
create_simple_features_dense(SEXP rdata, SEXP rnobs, SEXP rdim);

RcppExport SEXP
create_simple_features_sparse(SEXP rdata, SEXP rnobs, SEXP rdim);
#endif
