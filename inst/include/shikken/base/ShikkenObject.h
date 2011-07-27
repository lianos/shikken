#ifndef __SHIKKEN_OBJECT_H__
#define __SHIKKEN_OBJECT_H__

#include "Rcpp.h"

#include <shogun/base/SGObject.h>

namespace shikken {

class ShikkenObject {
    
public:
    ShikkenObject();
    ShikkenObject(SEXP robj);
    
    virtual ~ShikkenObject();
    
    virtual shogun::CSGObject* sg_ptr();
    
protected:
    Rcpp::S4* s4;
    shogun::CSGObject* sgptr;
    // Rcpp::S4 robject;
};

}

#endif

