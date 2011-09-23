#ifndef __SHIKKEN_FEATURES_LABELS_H__
#define __SHIKKEN_FEATURES_LABELS_H__

#include <shogun/features/Labels.h>

namespace shikken {

class Labels : public ShikkenObject
public:
    
    explicit Labels(SEXP rlabels);
    ~Labels();
    
    int length();

protected:
    
    shogun::CLabels* clabels;
}

#endif /* end of include guard: __SHIKKEN_FEATURES_LABELS_H__ */


