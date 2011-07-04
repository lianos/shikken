#ifndef __SHIKKEN_MEMORY_H__
#define __SHIKKEN_MEMORY_H__

#include <RcppCommon.h>
#include <shogun/base/SGObject.h>

/**
 * Decrements reference count to a shogun object and "clears" the R pointer
 * if count hits zero.
 * 
 * This method is called from within the C stack, and typically as the
 * "finalizer" parameter, eg:
 * 
 *   R_RegisterCFinalizer(some_shogun_obj_ptr, _shogun_ref_count_down); 
 */
static void _shogun_ref_count_down(SEXP ptr) {
    using namespace shogun;
    Rprintf("  [C] _shogun_ref_count_down triggered\n");
    if (TYPEOF(ptr) == EXTPTRSXP) {
        CSGObject *sptr = static_cast<CSGObject*>(R_ExternalPtrAddr(ptr));
        if (sptr) {
            Rprintf("  [C] ... decrementing ref count\n");
            if (sptr->unref() == 0) {
                // Explicitly deleting the pointer always segfaults, even
                // in the most trivial scenarios!
                // Rprintf(" [C] ... deleting pointer\n");
                // delete sptr;
                Rprintf(" [C] ... setting to NULL\n");
                sptr = NULL;
                // Rprintf("  [C] ... calling R_ClearExternalPtr, too\n");
                // R_ClearExternalPtr(ptr); // <- this just sets to NULL
            }
        }
    }
}

// Use Rcpp::XPtr<CSGObject*> wut(SEXP);
// template <typename T>
// SEXP SEXP2SG(SEXP o) {
// BEGIN_RCPP
//     if (TYPEOF(o) != EXTPTRSXP) {
//         std::runtime_error("invalid object to unwrap");
//     }
//     return (T*) R_ExternalPtrAddr(o);
// END_RCPP
// }

// template void foo<shogun::CSGObject(SEXP p);
// template<>
// void delete_finalizer<shogun::CSGObject>(SEXP p) {
//     if (TYPEOF(p) == EXTPTRSXP) {
//         CSGObject *sptr = static_cast<CSGObject*> (R_ExternalPtrAddr(p));
//         int32_t ref_count = -1;
//         if (sptr) {
//             Rprintf("  [C] ... decrementing ref count\n");
//             ref_count = sptr->unref();
//             if (ref_count == 0) {
//                 Rprintf("[C] ... deleting pointer\n");
//                 delete sptr;
//                 sptr = NULL;
//             }
//         }
//     }
// }


#endif
