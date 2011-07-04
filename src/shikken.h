#ifndef __SHIKKEN_SHIKKEN_H__
#define __SHIKKEN_SHIKKEN_H__

#ifdef __APPLE__
#define DARWIN 1
#endif

#include <RcppCommon.h>

#include "wrappers.h"
#include "memory.h"

#include <shogun/base/SGObject.h>
#include <shogun/lib/Mathematics.h>
#include <shogun/lib/common.h>
#include <shogun/base/init.h>

#include <Rcpp.h>


#define SHOGUN_VERSION "0.11-dev"

void r_print_message(FILE* target, const char* str);
void r_print_warning(FILE* target, const char* str);
void r_print_error(FILE* target, const char* str);
void r_cancel_computations(bool &delayed, bool &immediately);


/* Call a method by downcasting SVMPTR to more specifc type CLAZZ */
#define DCAST(SVMPTR, CLAZZ, METHOD, ...) \
do { \
    CLAZZ * CPTR = dynamic_cast<CLAZZ*>(SVMPTR); \
    CPTR->METHOD(## __VA_ARGS__); \
} while(0)

RcppExport SEXP shogun_ref_count_down(SEXP ptr);
RcppExport SEXP shogun_ref_count_up(SEXP ptr);
RcppExport SEXP shogun_ref_count(SEXP ptr);

RcppExport SEXP shogun_threads(SEXP n);

RcppExport SEXP shogun_version();
RcppExport SEXP init_shikken();
RcppExport SEXP exit_shikken();

#endif
