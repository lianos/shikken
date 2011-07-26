#include "shikken/base/ShikkenObject.h"

using namespace shikken;
    
ShikkenObject::ShikkenObject() {
    this->robject = NULL;
}

ShikkenObject::ShikkenObject(SEXP robj) {
    this->robject = robj;
}

ShikkenObject::~ShikkenObject() {
    this->robject = NULL;
}
