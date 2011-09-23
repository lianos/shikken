#ifndef __SHIKKEN_BASE_MEMORY_H__
#define __SHIKKEN_BASE_MEMORY_H__

#include <R.h>
#include <Rdefines.h>

#include "shikken/base/macros.h"

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

extern "C" {

static void shogun_ref_count_down_(SEXP ptr) {
    SHDEBUG("  [C] _shogun_ref_count_down triggered\n")
    if (TYPEOF(ptr) == EXTPTRSXP) {
        shogun::CSGObject *sptr = 
            static_cast<shogun::CSGObject*>(R_ExternalPtrAddr(ptr));
        if (sptr) {
            SHDEBUG("  [C] ... decrementing ref count\n")
            if (sptr->unref() == 0) {
                // Explicitly deleting the pointer always segfaults, even
                // in the most trivial scenarios!
                // delete sptr;
                SHDEBUG(" [C] ... setting to NULL\n")
                sptr = NULL;
                // Rprintf("  [C] ... calling R_ClearExternalPtr, too\n");
                // R_ClearExternalPtr(ptr); // <- this just sets to NULL
            }
        }
    }
}

}

#endif
