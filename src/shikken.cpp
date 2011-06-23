#include <shikken.h>

using namespace shogun;

void r_print_message(FILE* target, const char* str)
{
    if (target == stdout) {
        Rprintf((char*) "%s", str);
    } else {
        fprintf(target, "%s", str);
    }
}

void r_print_warning(FILE* target, const char* str)
{
    if (target == stdout) {
        Rprintf((char*) "%s", str);
    } else {
        fprintf(target, "%s", str);
    }
}

void r_print_error(FILE* target, const char* str)
{
    if (target != stdout) {
        fprintf(target, "%s", str);
    }
}

void r_cancel_computations(bool &delayed, bool &immediately)
{
    //R_Suicide((char*) "sg stopped by SIGINT\n");
    // see http://tolstoy.newcastle.edu.au/R/e13/devel/11/04/1045.html
    R_CheckUserInterrupt();
}

RcppExport SEXP shogun_version() {
BEGIN_RCPP
    return Rcpp::wrap(SHOGUN_VERSION);
END_RCPP
}

RcppExport SEXP init_shikken() {
BEGIN_RCPP
    init_shogun(&r_print_message, &r_print_warning, &r_print_error,
                &r_cancel_computations);
    
    return R_NilValue;
END_RCPP
}

RcppExport SEXP exit_shikken() {
    exit_shogun();
    return R_NilValue;
}

/* ------------------------- Shogun Object Disposal ------------------------ */
/* Some trial and error here */
RcppExport void _dispose_shogun_pointer(SEXP ptr) {
    Rprintf("  [C] _dispose_shogun_pointer triggered\n");
    CSGObject* sptr = reinterpret_cast<CSGObject*>(R_ExternalPtrAddr(ptr));
    if (sptr) {
        if (sptr->unref() == 0) {
            sptr = NULL;
            Rprintf("  ... calling R_ClearExternalPtr, too\n");
            R_ClearExternalPtr(ptr);
        }
    }
}

// Call from R? For example:
// dipose <- function(x) .Call("dispose_shogun_pointer", externalptr)
// ...
// reg.finalizer(some.shogun.ptr, disposeShogunPointer)
RcppExport SEXP dispose_shogun_pointer(SEXP ptr) {
    _dispose_shogun_pointer(ptr);
    return R_NilValue;
}

/* Trying with Rcpp::Xptr, but not working
RcppExport SEXP dispose_shogun_object(SEXP obj) {
BEGIN_RCPP
    Rcpp::XPtr<CSGObject> optr(obj);
    // SG_UNREF(optr);
    // grab the inlined macro
    if (optr) {
        if (optr->unref() == 0) {
            //optr = NULL;
        }
    }
    return R_NilValue;
END_RCPP
}
*/