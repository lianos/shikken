#ifndef __SHIKKEN_SKERNEL_MACHINE_H__
#define __SHIKKEN_SKERNEL_MACHINE_H__

#include <shogun/machine/KernelMachine.h>

#include "shikken/base/ShikkenObject.h"


namespace shikken {

class KernelMachine : public ShikkenObject {
public:
    
    /** Used in place of as<shikken::KernelMachine> */
    KernelMachine(SEXP rkmachine);
    virtual ~KernelMachine();
    
    virtual void train();
    
    
    virtual SEXP predict();
    virtual SEXP predict(SEXP rfeatures);

protected:
    /** Pointer to the shogun::CKernelMachine */
    shogun::CKernelMachine* ckm;

};

}

#endif
