#include <shikken.h>

// extern "C" {
// SEXP shogun_version() {
//     Rcpp::wrap(SHOGUN_VERSION);
// }
// 
// }

void r_print_message(FILE* target, const char* str)
{
    if (target==stdout) {
        Rprintf((char*) "%s", str);
    } else {
        fprintf(target, "%s", str);
    }
}

void r_print_warning(FILE* target, const char* str)
{
    if (target==stdout) {
        Rprintf((char*) "%s", str);
    } else {
        fprintf(target, "%s", str);
    }
}

void r_print_error(FILE* target, const char* str)
{
    if (target!=stdout) {
        fprintf(target, "%s", str);
    }
}

void r_cancel_computations(bool &delayed, bool &immediately)
{
    //R_Suicide((char*) "sg stopped by SIGINT\n");
    // see http://tolstoy.newcastle.edu.au/R/e13/devel/11/04/1045.html
    R_CheckUserInterrupt();
}

RcppExport SEXP dispose_shogun_object(SEXP obj) {
BEGIN_RCPP
    Rcpp::XPtr<CSGObject> obj_ptr(obj);
    SG_UNREF(obj_ptr);
    return R_NilValue;
END_RCPP
}
RcppExport SEXP shogun_version() {
BEGIN_RCPP
    return Rcpp::wrap(SHOGUN_VERSION);
END_RCPP
}

RcppExport SEXP init_shikken() {
BEGIN_RCPP
    shogun::init_shogun(&r_print_message, &r_print_warning, &r_print_error,
                        &r_cancel_computations);
    
    return R_NilValue;
END_RCPP
}

RcppExport SEXP exit_shikken() {
    shogun::exit_shogun();
    return R_NilValue;
}
