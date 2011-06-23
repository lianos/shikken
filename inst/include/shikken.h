#ifndef __SHIKKEN_SHIKKEN_H__
#define __SHIKKEN_SHIKKEN_H__

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

RcppExport void _dispose_shogun_pointer(SEXP ptr);
RcppExport SEXP dispose_shogun_pointer(SEXP ptr);
RcppExport SEXP dispose_shogun_object(SEXP obj);
RcppExport SEXP shogun_version();
RcppExport SEXP init_shikken();
RcppExport SEXP exit_shikken();

#endif
