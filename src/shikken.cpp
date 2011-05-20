#include <shikken.h>

extern "C" SEXP shogun_version() {
    Rcpp::wrap(SHOGUN_VERSION);
}
