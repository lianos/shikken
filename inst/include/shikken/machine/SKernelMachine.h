#ifndef __SHIKKEN_SKERNEL_MACHINE_H__
#define __SHIKKEN_SKERNEL_MACHINE_H__

#include <shogun/features/Labels.h>

// dense feature matrices
//  SimpleFeatures extends DotFeatures extends Features
#include <shogun/features/SimpleFeatures.h>

// StringFeatures extend Features
#include <shogun/features/StringFeatures.h>
// StringFeatures that are file based through Memory-mapped files.
#include <shogun/features/StringFileFeatures.h>

// dotfeatures for polyhnomial kernel
#include <shogun/features/PolyFeatures.h>

// CombinedFeatures extend Features
#include <shogun/features/CombinedFeatures.h>
// extend DotFeatures
#include <shogun/features/CombinedDotFeatures.h>

// SparseFeatures extends DotFeatures extends Features
#include <shogun/features/SparseFeatures.h>
#include <shogun/features/SparsePolyFeatures.h>

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
    virtual SEXP predict_on(SEXP rfeatures);

protected:
    /** Pointer to the shogun::CKernelMachine */
    shogun::CKernelMachine* ckm;

};

}

#endif
