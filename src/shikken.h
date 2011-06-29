#ifndef __SHIKKEN_SHIKKEN_H__
#define __SHIKKEN_SHIKKEN_H__

#ifdef __APPLE__
#define DARWIN 1
#endif

#include <Rcpp.h>

#include <shogun/base/SGObject.h>
#include <shogun/lib/Mathematics.h>
#include <shogun/lib/common.h>
#include <shogun/base/init.h>

#define SHOGUN_VERSION "0.11-dev"

void r_print_message(FILE* target, const char* str);
void r_print_warning(FILE* target, const char* str);
void r_print_error(FILE* target, const char* str);
void r_cancel_computations(bool &delayed, bool &immediately);

/* wrap the (CSGObject *) into a SEXP */
#define SK_WRAP(o,r) \
do { \
    r = R_MakeExternalPtr(o, R_NilValue, R_NilValue); \
    R_RegisterCFinalizer(r, _shogun_ref_count_down); \
} while(0)

void _shogun_ref_count_down(SEXP ptr);
RcppExport SEXP shogun_ref_count_down(SEXP ptr);
RcppExport SEXP shogun_ref_count_up(SEXP ptr);
RcppExport SEXP shogun_ref_count(SEXP ptr);

RcppExport SEXP shogun_threads(SEXP n);

RcppExport SEXP shogun_version();
RcppExport SEXP init_shikken();
RcppExport SEXP exit_shikken();

#endif
