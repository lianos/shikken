#ifndef __SHIKKEN_LABELS_H__
#define __SHIKKEN_LABELS_H__

/////////////////////////////////////////////////////////////////////// Imports
#include "shikken.h"
#include <shogun/features/Labels.h>

RcppExport SEXP labels_create(SEXP rlabels);
RcppExport SEXP labels_length(SEXP rlabels);
RcppExport SEXP labels_get(SEXP rlabels);

#endif
