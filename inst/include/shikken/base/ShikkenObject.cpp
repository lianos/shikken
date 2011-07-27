#include "shikken/base/ShikkenObject.h"
#include "Rcpp.h"

using namespace shikken;
    
ShikkenObject::ShikkenObject() {
    this->sgptr = NULL;
}

ShikkenObject::ShikkenObject(SEXP robj) {
    this->s4 = new Rcpp::S4(robj);
    void *extptr = R_ExternalPtrAddr(SEXP(s4->slot("sg.ptr")));
    this->sgptr = static_cast<shogun::CSGObject*>(extptr);
}

ShikkenObject::~ShikkenObject() {
    delete this->s4;
}

shogun::CSGObject * ShikkenObject::sg_ptr() {
    return this->sgptr;
}
