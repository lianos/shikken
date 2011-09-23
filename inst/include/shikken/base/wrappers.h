#ifndef __SHIKKEN_WRAPPERS_H__
#define __SHIKKEN_WRAPPERS_H__

#include <R.h>
#include <Rdefines.h>

#include <shogun/base/SGObject.h>

SEXP SG2SEXP(shogun::CSGObject *o);

// #include <RcppCommon.h>
// namespace Rcpp {
    // Getting inspiration from RcppBDT.h
    // non-intrusive via template specialization
    // template <typename T>
    // shogun::SGVector<T> as(SEXP v) throw(not_compatible);
    
    // template <typename T>
    // shogun::SGMatrix<T> as(SEXP m) throw(not_compatible);
    
    // template <typename T>
    // SEXP wrap(const shogun::SGVector<T> &v) throw(not_compatible);
    // 
    // template <typename T>
    // SEXP wrap(const shogun::SGMatrix<T> &m) throw(not_compatible);
// }

#endif
