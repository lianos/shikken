// tranlsated from:
// http://www.shogun-toolbox.org/doc/developer_tutorial.html

#include <shikken.h>

#include <shogun/features/Labels.h>
#include <shogun/features/SimpleFeatures.h>
#include <shogun/kernel/GaussianKernel.h>
#include <shogun/classifier/svm/LibSVM.h>
#include <shogun/base/init.h>
#include <shogun/lib/common.h>
#include <shogun/lib/io.h>
#include <stdio.h>

using namespace shogun;

extern "C" {

SEXP gaussian_kernel_example(SEXP values_, SEXP dims_, SEXP labels_);
// shogun features are stored in column order, where each column denotes
// a feature vector (just like "normal" R)
SEXP gaussian_kernel_example(SEXP values_, SEXP dims_, SEXP labels_) {
  Rcpp::NumericVector values(values_);
  Rcpp::IntegerVector dims(dims_);
  Rcpp::NumericVector rlabels(labels_);
  float64_t tmp;
  std::vector<float64_t> result;
  
  Rprintf("Converting values\n");
  float64_t* matrix = new float64_t[values.size()];
  for (int32_t i=0; i < values.size(); i++) {
    matrix[i]=values[i];
  }
  
  Rprintf("Setting features\n");
  CSimpleFeatures<float64_t>* features = new CSimpleFeatures<float64_t>();
  
  // columns are linear in memory
  // 2nd param is the number of features in matrix
  // 3rd param is the number of vectors in matrix
  // in R, typically rows are observations and columns are features
  features->set_feature_matrix(matrix, dims[1], dims[0]);
  
  Rprintf("Crating labels\n");
  // create labels
  CLabels* labels = new CLabels(dims[0]);
  for (int32_t i = 0; i < dims[0]; i++) {
    labels->set_label(i, rlabels[i]);
  }
  
  Rprintf("Creating kernel\n");
  // create gaussian kernel with cache 10MB, width 0.5
  CGaussianKernel* kernel = new CGaussianKernel(10, 0.5);
  kernel->init(features, features);
  
  Rprintf("Initializing SVM\n");
  // create libsvm with C=10 and train
  CLibSVM* svm = new CLibSVM(10, kernel, labels);
  
  Rprintf("Training SVM\n");
  svm->train();
  
  Rprintf("Running predictions\n");
  CLabels* preds = svm->apply();
  // classify on training examples
  for (int32_t i=0; i < dims[0]; i++) {
    tmp = preds->get_label(i);
    // Rprintf("output[%d]=%f\n", i, tmp);
    SG_SPRINT("output[%d]=%f\n", i, tmp);
    result.push_back(tmp);
  }
  
  Rprintf("Freeing memory\n");
  // free up memory
  SG_UNREF(svm);
  
  return Rcpp::wrap(result);
}

}