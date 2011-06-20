#ifndef __SHIKKEN_SHIKKEN_H__
#define __SHIKKEN_SHIKKEN_H__

#include <Rcpp.h>

#include "shogun/lib/Mathematics.h"
#include "shogun/lib/common.h"
#include "shogun/base/init.h"

#include "kernels.h"
#include "features.h"

#define SHOGUN_VERSION "0.11-dev"

void r_print_message(FILE* target, const char* str);
void r_print_warning(FILE* target, const char* str);
void r_print_error(FILE* target, const char* str);
void r_cancel_computations(bool &delayed, bool &immediately);

extern "C" {
    SEXP shogun_version();
    SEXP init_shikken();
    SEXP exit_shikken();
}

#endif
