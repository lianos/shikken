#ifndef __SHIKKEN_OBJECT_H__
#define __SHIKKEN_OBJECT_H__

#include <R.h>
#include <Rinternals.h>

namespace shikken {

class ShikkenObject {
    
public:
    ShikkenObject();
    ShikkenObject(SEXP robj);
    
    virtual ~ShikkenObject();
    
private:
    SEXP robject;
};

}

#endif

