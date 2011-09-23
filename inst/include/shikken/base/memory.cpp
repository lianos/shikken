#include "shikken/base/memory.h"
#include "shikken/base/macros.h"

#include <shogun/base/SGObject.h>

// void shogun_ref_count_down_(SEXP ptr) {
//     SHDEBUG("  [C] _shogun_ref_count_down triggered\n")
//     if (TYPEOF(ptr) == EXTPTRSXP) {
//         shogun::CSGObject *sptr = 
//             static_cast<shogun::CSGObject*>(R_ExternalPtrAddr(ptr));
//         if (sptr) {
//             SHDEBUG("  [C] ... decrementing ref count\n")
//             if (sptr->unref() == 0) {
//                 // Explicitly deleting the pointer always segfaults, even
//                 // in the most trivial scenarios!
//                 // delete sptr;
//                 SHDEBUG(" [C] ... setting to NULL\n")
//                 sptr = NULL;
//                 // Rprintf("  [C] ... calling R_ClearExternalPtr, too\n");
//                 // R_ClearExternalPtr(ptr); // <- this just sets to NULL
//             }
//         }
//     }
// }
