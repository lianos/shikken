#include "wrappers.h"

SEXP SG2SEXP(shogun::CSGObject *o) {
    SEXP xp = R_MakeExternalPtr(o, R_NilValue, R_NilValue);
    //R_RegisterCFinalizerEx(xp, _shogun_ref_count_down, TRUE);
    R_RegisterCFinalizer(xp, _shogun_ref_count_down);
    return xp;
}


namespace Rcpp {
    // template <typename T>
    // shogun::SGVector<T> as(SEXP v) throw(not_compatible) {
    //     SGVector<T> vec(DATAPTR(v), LENGTH(v));
    //     return vec;
    // }
    // template <typename T>
    // shogun::SGMatrix<T> as(SEXP m) throw(not_compatible) {
    //     SGMatrix<T> mat(DATAPTR(m), GET_DIM(m)[0], GET_DIM(m)[1])
    //     return mat;
    // }
    
    // template <typename T>
    // SEXP wrap(const shogun::SGVector<T> &v) throw(not_compatible) {
    //     ::Rcpp
    // }
    // 
    // template <typename T>
    // SEXP wrap(const shogun::SGMatrix<T> &m) throw(not_compatible) {
    //     
    // }
}