#include "labels.h"
using namespace Rcpp;

// This won't work -- lots of shogun classes have overloaded methods.
// and Modules do not support that (yet).
// 
// RCPP_MODULE(labels_module) {
//     class_<CLabels>("SGLabels")
//         .constructor<double*,int>()
//         .field()
//         .field()
//         .method("get_num_classes", &CLabels::get_num_classes)
//         .method("get_labels")
// }
