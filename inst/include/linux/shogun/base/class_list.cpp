/*
 * THIS IS A GENERATED FILE!  DO NOT CHANGE THIS FILE!  CHANGE THE
 * CORRESPONDING TEMPLAT FILE, PLEASE!
 */

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 2009 Soeren Sonnenburg
 * Copyright (C) 2009 Fraunhofer Institute FIRST and Max-Planck-Society
 */

#include "lib/common.h"
#include "base/class_list.h"

#include <string.h>

#include "kernel/Kernel.h"

#include "distance/ChebyshewMetric.h"
#include "distance/MinkowskiMetric.h"
#include "distance/ChiSquareDistance.h"
#include "distance/CanberraWordDistance.h"
#include "distance/CustomDistance.h"
#include "distance/JensenMetric.h"
#include "distance/GeodesicMetric.h"
#include "distance/AttenuatedEuclidianDistance.h"
#include "distance/HammingWordDistance.h"
#include "distance/EuclidianDistance.h"
#include "distance/CanberraMetric.h"
#include "distance/TanimotoDistance.h"
#include "distance/ManhattanMetric.h"
#include "distance/BrayCurtisDistance.h"
#include "distance/ManhattanWordDistance.h"
#include "distance/KernelDistance.h"
#include "distance/CosineDistance.h"
#include "distance/SparseEuclidianDistance.h"
#include "distributions/HMM.h"
#include "distributions/LinearHMM.h"
#include "distributions/Histogram.h"
#include "distributions/GHMM.h"
#include "distributions/PositionalPWM.h"
#include "classifier/KernelPerceptron.h"
#include "classifier/KNN.h"
#include "classifier/GaussianNaiveBayes.h"
#include "classifier/mkl/MKLOneClass.h"
#include "classifier/mkl/MKLClassification.h"
#include "classifier/mkl/MKLMultiClass.h"
#include "classifier/Perceptron.h"
#include "classifier/svm/MultiClassSVM.h"
#include "classifier/svm/GNPPLib.h"
#include "classifier/svm/SVMLin.h"
#include "classifier/svm/DomainAdaptationSVM.h"
#include "classifier/svm/LaRank.h"
#include "classifier/svm/MPDSVM.h"
#include "classifier/svm/ScatterSVM.h"
#include "classifier/svm/SGDQN.h"
#include "classifier/svm/WDSVMOcas.h"
#include "classifier/svm/SVMLightOneClass.h"
#include "classifier/svm/LibSVMMultiClass.h"
#include "classifier/svm/GPBTSVM.h"
#include "classifier/svm/SVMOcas.h"
#include "classifier/svm/SubGradientSVM.h"
#include "classifier/svm/SVMSGD.h"
#include "classifier/svm/LibSVM.h"
#include "classifier/svm/GMNPLib.h"
#include "classifier/svm/GMNPSVM.h"
#include "classifier/svm/LibSVMOneClass.h"
#include "classifier/svm/QPBSVMLib.h"
#include "classifier/svm/SVMLight.h"
#include "classifier/svm/SVM.h"
#include "classifier/svm/GNPPSVM.h"
#include "classifier/PluginEstimate.h"
#include "classifier/AveragedPerceptron.h"
#include "features/Subset.h"
#include "features/HashedWDFeaturesTransposed.h"
#include "features/StringFileFeatures.h"
#include "features/SNPFeatures.h"
#include "features/ExplicitSpecFeatures.h"
#include "features/SparseFeatures.h"
#include "features/StreamingSimpleFeatures.h"
#include "features/PolyFeatures.h"
#include "features/ImplicitWeightedSpecFeatures.h"
#include "features/StreamingSparseFeatures.h"
#include "features/TOPFeatures.h"
#include "features/SparsePolyFeatures.h"
#include "features/Labels.h"
#include "features/WDFeatures.h"
#include "features/SimpleFeatures.h"
#include "features/HashedWDFeatures.h"
#include "features/Alphabet.h"
#include "features/CombinedFeatures.h"
#include "features/StreamingStringFeatures.h"
#include "features/RealFileFeatures.h"
#include "features/DummyFeatures.h"
#include "features/StringFeatures.h"
#include "features/CombinedDotFeatures.h"
#include "features/FKFeatures.h"
#include "features/LBPPyrDotFeatures.h"
#include "clustering/KMeans.h"
#include "clustering/Hierarchical.h"
#include "machine/KernelMachine.h"
#include "machine/LinearMachine.h"
#include "structure/PlifMatrix.h"
#include "structure/Plif.h"
#include "structure/PlifArray.h"
#include "structure/DynProg.h"
#include "structure/IntronList.h"
#include "structure/SegmentLoss.h"
#include "lib/List.h"
#include "lib/Set.h"
#include "lib/BinaryStream.h"
#include "lib/DynamicArray.h"
#include "lib/Array2.h"
#include "lib/Time.h"
#include "lib/Cache.h"
#include "lib/Array3.h"
#include "lib/StreamingFile.h"
#include "lib/BinaryFile.h"
#include "lib/Compressor.h"
#include "lib/BitString.h"
#include "lib/StreamingFileFromSimpleFeatures.h"
#include "lib/AsciiFile.h"
#include "lib/IOBuffer.h"
#include "lib/SimpleFile.h"
#include "lib/StreamingAsciiFile.h"
#include "lib/Signal.h"
#include "lib/MemoryMappedFile.h"
#include "lib/StreamingFileFromFeatures.h"
#include "lib/Array.h"
#include "lib/DynamicArrayPtr.h"
#include "lib/SerializableAsciiFile.h"
#include "lib/Hash.h"
#include "evaluation/MeanSquaredError.h"
#include "evaluation/StratifiedCrossValidationSplitting.h"
#include "evaluation/PRCEvaluation.h"
#include "evaluation/ROCEvaluation.h"
#include "evaluation/ContingencyTableEvaluation.h"
#include "evaluation/MulticlassAccuracy.h"
#include "evaluation/CrossValidation.h"
#include "regression/svr/MKLRegression.h"
#include "regression/svr/LibSVR.h"
#include "regression/svr/SVRLight.h"
#include "kernel/HistogramIntersectionKernel.h"
#include "kernel/MultitaskKernelTreeNormalizer.h"
#include "kernel/SNPStringKernel.h"
#include "kernel/MultitaskKernelMaskNormalizer.h"
#include "kernel/CircularKernel.h"
#include "kernel/FixedDegreeStringKernel.h"
#include "kernel/CombinedKernel.h"
#include "kernel/SphericalKernel.h"
#include "kernel/ExponentialKernel.h"
#include "kernel/PowerKernel.h"
#include "kernel/SqrtDiagKernelNormalizer.h"
#include "kernel/MultitaskKernelMaskPairNormalizer.h"
#include "kernel/Chi2Kernel.h"
#include "kernel/GaussianKernel.h"
#include "kernel/WaveletKernel.h"
#include "kernel/ScatterKernelNormalizer.h"
#include "kernel/DistanceKernel.h"
#include "kernel/MultitaskKernelPlifNormalizer.h"
#include "kernel/RidgeKernelNormalizer.h"
#include "kernel/IdentityKernelNormalizer.h"
#include "kernel/CommUlongStringKernel.h"
#include "kernel/SparseSpatialSampleStringKernel.h"
#include "kernel/CustomKernel.h"
#include "kernel/WaveKernel.h"
#include "kernel/SigmoidKernel.h"
#include "kernel/TanimotoKernelNormalizer.h"
#include "kernel/AUCKernel.h"
#include "kernel/LocalityImprovedStringKernel.h"
#include "kernel/GaussianShiftKernel.h"
#include "kernel/ConstKernel.h"
#include "kernel/PolyMatchWordStringKernel.h"
#include "kernel/InverseMultiQuadricKernel.h"
#include "kernel/SalzbergWordStringKernel.h"
#include "kernel/PolyMatchStringKernel.h"
#include "kernel/MultiquadricKernel.h"
#include "kernel/DiceKernelNormalizer.h"
#include "kernel/LogKernel.h"
#include "kernel/SpectrumMismatchRBFKernel.h"
#include "kernel/LinearKernel.h"
#include "kernel/AvgDiagKernelNormalizer.h"
#include "kernel/DiagKernel.h"
#include "kernel/RegulatoryModulesStringKernel.h"
#include "kernel/PyramidChi2.h"
#include "kernel/WeightedDegreeRBFKernel.h"
#include "kernel/BesselKernel.h"
#include "kernel/SimpleLocalityImprovedStringKernel.h"
#include "kernel/LocalAlignmentStringKernel.h"
#include "kernel/ZeroMeanCenterKernelNormalizer.h"
#include "kernel/GaussianMatchStringKernel.h"
#include "kernel/PolyKernel.h"
#include "kernel/DistantSegmentsKernel.h"
#include "kernel/MultitaskKernelNormalizer.h"
#include "kernel/CauchyKernel.h"
#include "kernel/FirstElementKernelNormalizer.h"
#include "kernel/MatchWordStringKernel.h"
#include "kernel/SplineKernel.h"
#include "kernel/RationalQuadraticKernel.h"
#include "kernel/GaussianShortRealKernel.h"
#include "kernel/LinearStringKernel.h"
#include "kernel/WeightedDegreeStringKernel.h"
#include "kernel/HistogramWordStringKernel.h"
#include "kernel/TensorProductPairKernel.h"
#include "kernel/TStudentKernel.h"
#include "kernel/WeightedDegreePositionStringKernel.h"
#include "kernel/ANOVAKernel.h"
#include "kernel/OligoStringKernel.h"
#include "kernel/CommWordStringKernel.h"
#include "kernel/SpectrumRBFKernel.h"
#include "kernel/WeightedCommWordStringKernel.h"
#include "kernel/VarianceKernelNormalizer.h"
#include "preprocessor/NormOne.h"
#include "preprocessor/DimensionReductionPreprocessor.h"
#include "preprocessor/PruneVarSubMean.h"
#include "preprocessor/SortUlongString.h"
#include "preprocessor/SortWordString.h"
#include "preprocessor/LogPlusOne.h"
#include "preprocessor/DecompressString.h"
#include "preprocessor/RandomFourierGaussPreproc.h"
#include "modelselection/ModelSelectionParameters.h"
#include "modelselection/GridSearchModelSelection.h"
using namespace shogun;

static CSGObject* __new_CChebyshewMetric(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CChebyshewMetric(): NULL; }
static CSGObject* __new_CMinkowskiMetric(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMinkowskiMetric(): NULL; }
static CSGObject* __new_CChiSquareDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CChiSquareDistance(): NULL; }
static CSGObject* __new_CCanberraWordDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCanberraWordDistance(): NULL; }
static CSGObject* __new_CCustomDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCustomDistance(): NULL; }
static CSGObject* __new_CJensenMetric(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CJensenMetric(): NULL; }
static CSGObject* __new_CGeodesicMetric(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGeodesicMetric(): NULL; }
static CSGObject* __new_CAttenuatedEuclidianDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAttenuatedEuclidianDistance(): NULL; }
static CSGObject* __new_CHammingWordDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHammingWordDistance(): NULL; }
static CSGObject* __new_CEuclidianDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CEuclidianDistance(): NULL; }
static CSGObject* __new_CCanberraMetric(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCanberraMetric(): NULL; }
static CSGObject* __new_CTanimotoDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTanimotoDistance(): NULL; }
static CSGObject* __new_CManhattanMetric(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CManhattanMetric(): NULL; }
static CSGObject* __new_CBrayCurtisDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CBrayCurtisDistance(): NULL; }
static CSGObject* __new_CManhattanWordDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CManhattanWordDistance(): NULL; }
static CSGObject* __new_CKernelDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CKernelDistance(): NULL; }
static CSGObject* __new_CCosineDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCosineDistance(): NULL; }
static CSGObject* __new_CSparseEuclidianDistance(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSparseEuclidianDistance(): NULL; }
static CSGObject* __new_CHMM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHMM(): NULL; }
static CSGObject* __new_CLinearHMM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLinearHMM(): NULL; }
static CSGObject* __new_CHistogram(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHistogram(): NULL; }
static CSGObject* __new_CGHMM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGHMM(): NULL; }
static CSGObject* __new_CPositionalPWM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPositionalPWM(): NULL; }
static CSGObject* __new_CKernelPerceptron(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CKernelPerceptron(): NULL; }
static CSGObject* __new_CKNN(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CKNN(): NULL; }
static CSGObject* __new_CGaussianNaiveBayes(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGaussianNaiveBayes(): NULL; }
static CSGObject* __new_CMKLOneClass(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMKLOneClass(): NULL; }
static CSGObject* __new_CMKLClassification(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMKLClassification(): NULL; }
static CSGObject* __new_CMKLMultiClass(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMKLMultiClass(): NULL; }
static CSGObject* __new_CPerceptron(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPerceptron(): NULL; }
static CSGObject* __new_CMultiClassSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultiClassSVM(): NULL; }
static CSGObject* __new_CGNPPLib(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGNPPLib(): NULL; }
static CSGObject* __new_CSVMLin(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVMLin(): NULL; }
static CSGObject* __new_CDomainAdaptationSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDomainAdaptationSVM(): NULL; }
static CSGObject* __new_CLaRank(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLaRank(): NULL; }
static CSGObject* __new_CMPDSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMPDSVM(): NULL; }
static CSGObject* __new_CScatterSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CScatterSVM(): NULL; }
static CSGObject* __new_CSGDQN(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSGDQN(): NULL; }
static CSGObject* __new_CWDSVMOcas(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWDSVMOcas(): NULL; }
static CSGObject* __new_CSVMLightOneClass(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVMLightOneClass(): NULL; }
static CSGObject* __new_CLibSVMMultiClass(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLibSVMMultiClass(): NULL; }
static CSGObject* __new_CGPBTSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGPBTSVM(): NULL; }
static CSGObject* __new_CSVMOcas(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVMOcas(): NULL; }
static CSGObject* __new_CSubGradientSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSubGradientSVM(): NULL; }
static CSGObject* __new_CSVMSGD(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVMSGD(): NULL; }
static CSGObject* __new_CLibSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLibSVM(): NULL; }
static CSGObject* __new_CGMNPLib(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGMNPLib(): NULL; }
static CSGObject* __new_CGMNPSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGMNPSVM(): NULL; }
static CSGObject* __new_CLibSVMOneClass(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLibSVMOneClass(): NULL; }
static CSGObject* __new_CQPBSVMLib(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CQPBSVMLib(): NULL; }
static CSGObject* __new_CSVMLight(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVMLight(): NULL; }
static CSGObject* __new_CSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVM(): NULL; }
static CSGObject* __new_CGNPPSVM(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGNPPSVM(): NULL; }
static CSGObject* __new_CPluginEstimate(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPluginEstimate(): NULL; }
static CSGObject* __new_CAveragedPerceptron(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAveragedPerceptron(): NULL; }
static CSGObject* __new_CSubset(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSubset(): NULL; }
static CSGObject* __new_CHashedWDFeaturesTransposed(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHashedWDFeaturesTransposed(): NULL; }
static CSGObject* __new_CSNPFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSNPFeatures(): NULL; }
static CSGObject* __new_CExplicitSpecFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CExplicitSpecFeatures(): NULL; }
static CSGObject* __new_CPolyFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPolyFeatures(): NULL; }
static CSGObject* __new_CImplicitWeightedSpecFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CImplicitWeightedSpecFeatures(): NULL; }
static CSGObject* __new_CTOPFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTOPFeatures(): NULL; }
static CSGObject* __new_CSparsePolyFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSparsePolyFeatures(): NULL; }
static CSGObject* __new_CLabels(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLabels(): NULL; }
static CSGObject* __new_CWDFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWDFeatures(): NULL; }
static CSGObject* __new_CHashedWDFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHashedWDFeatures(): NULL; }
static CSGObject* __new_CAlphabet(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAlphabet(): NULL; }
static CSGObject* __new_CCombinedFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCombinedFeatures(): NULL; }
static CSGObject* __new_CRealFileFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CRealFileFeatures(): NULL; }
static CSGObject* __new_CDummyFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDummyFeatures(): NULL; }
static CSGObject* __new_CCombinedDotFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCombinedDotFeatures(): NULL; }
static CSGObject* __new_CFKFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CFKFeatures(): NULL; }
static CSGObject* __new_CLBPPyrDotFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLBPPyrDotFeatures(): NULL; }
static CSGObject* __new_CKMeans(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CKMeans(): NULL; }
static CSGObject* __new_CHierarchical(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHierarchical(): NULL; }
static CSGObject* __new_CKernelMachine(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CKernelMachine(): NULL; }
static CSGObject* __new_CLinearMachine(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLinearMachine(): NULL; }
static CSGObject* __new_CPlifMatrix(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPlifMatrix(): NULL; }
static CSGObject* __new_CPlif(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPlif(): NULL; }
static CSGObject* __new_CPlifArray(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPlifArray(): NULL; }
static CSGObject* __new_CDynProg(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDynProg(): NULL; }
static CSGObject* __new_CIntronList(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CIntronList(): NULL; }
static CSGObject* __new_CSegmentLoss(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSegmentLoss(): NULL; }
static CSGObject* __new_CListElement(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CListElement(): NULL; }
static CSGObject* __new_CList(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CList(): NULL; }
static CSGObject* __new_CTime(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTime(): NULL; }
static CSGObject* __new_CStreamingFile(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CStreamingFile(): NULL; }
static CSGObject* __new_CBinaryFile(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CBinaryFile(): NULL; }
static CSGObject* __new_CCompressor(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCompressor(): NULL; }
static CSGObject* __new_CBitString(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CBitString(): NULL; }
static CSGObject* __new_CStreamingFileFromSimpleFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CStreamingFileFromSimpleFeatures(): NULL; }
static CSGObject* __new_CAsciiFile(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAsciiFile(): NULL; }
static CSGObject* __new_CMath(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMath(): NULL; }
static CSGObject* __new_CIOBuffer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CIOBuffer(): NULL; }
static CSGObject* __new_CStreamingAsciiFile(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CStreamingAsciiFile(): NULL; }
static CSGObject* __new_CSignal(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSignal(): NULL; }
static CSGObject* __new_CStreamingFileFromFeatures(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CStreamingFileFromFeatures(): NULL; }
static CSGObject* __new_CDynamicArrayPtr(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDynamicArrayPtr(): NULL; }
static CSGObject* __new_CSerializableAsciiFile(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSerializableAsciiFile(): NULL; }
static CSGObject* __new_CHash(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHash(): NULL; }
static CSGObject* __new_CMeanSquaredError(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMeanSquaredError(): NULL; }
static CSGObject* __new_CStratifiedCrossValidationSplitting(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CStratifiedCrossValidationSplitting(): NULL; }
static CSGObject* __new_CPRCEvaluation(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPRCEvaluation(): NULL; }
static CSGObject* __new_CROCEvaluation(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CROCEvaluation(): NULL; }
static CSGObject* __new_CContingencyTableEvaluation(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CContingencyTableEvaluation(): NULL; }
static CSGObject* __new_CAccuracyMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAccuracyMeasure(): NULL; }
static CSGObject* __new_CErrorRateMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CErrorRateMeasure(): NULL; }
static CSGObject* __new_CBALMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CBALMeasure(): NULL; }
static CSGObject* __new_CWRACCMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWRACCMeasure(): NULL; }
static CSGObject* __new_CF1Measure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CF1Measure(): NULL; }
static CSGObject* __new_CCrossCorrelationMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCrossCorrelationMeasure(): NULL; }
static CSGObject* __new_CRecallMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CRecallMeasure(): NULL; }
static CSGObject* __new_CPrecisionMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPrecisionMeasure(): NULL; }
static CSGObject* __new_CSpecificityMeasure(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSpecificityMeasure(): NULL; }
static CSGObject* __new_CMulticlassAccuracy(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMulticlassAccuracy(): NULL; }
static CSGObject* __new_CCrossValidation(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCrossValidation(): NULL; }
static CSGObject* __new_CMKLRegression(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMKLRegression(): NULL; }
static CSGObject* __new_CLibSVR(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLibSVR(): NULL; }
static CSGObject* __new_CSVRLight(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSVRLight(): NULL; }
static CSGObject* __new_CHistogramIntersectionKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHistogramIntersectionKernel(): NULL; }
static CSGObject* __new_CNode(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CNode(): NULL; }
static CSGObject* __new_CTaxonomy(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTaxonomy(): NULL; }
static CSGObject* __new_CMultitaskKernelTreeNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultitaskKernelTreeNormalizer(): NULL; }
static CSGObject* __new_CSNPStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSNPStringKernel(): NULL; }
static CSGObject* __new_CMultitaskKernelMaskNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultitaskKernelMaskNormalizer(): NULL; }
static CSGObject* __new_CCircularKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCircularKernel(): NULL; }
static CSGObject* __new_CFixedDegreeStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CFixedDegreeStringKernel(): NULL; }
static CSGObject* __new_CCombinedKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCombinedKernel(): NULL; }
static CSGObject* __new_CSphericalKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSphericalKernel(): NULL; }
static CSGObject* __new_CExponentialKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CExponentialKernel(): NULL; }
static CSGObject* __new_CPowerKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPowerKernel(): NULL; }
static CSGObject* __new_CSqrtDiagKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSqrtDiagKernelNormalizer(): NULL; }
static CSGObject* __new_CMultitaskKernelMaskPairNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultitaskKernelMaskPairNormalizer(): NULL; }
static CSGObject* __new_CChi2Kernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CChi2Kernel(): NULL; }
static CSGObject* __new_CGaussianKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGaussianKernel(): NULL; }
static CSGObject* __new_CWaveletKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWaveletKernel(): NULL; }
static CSGObject* __new_CScatterKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CScatterKernelNormalizer(): NULL; }
static CSGObject* __new_CDistanceKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDistanceKernel(): NULL; }
static CSGObject* __new_CMultitaskKernelPlifNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultitaskKernelPlifNormalizer(): NULL; }
static CSGObject* __new_CRidgeKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CRidgeKernelNormalizer(): NULL; }
static CSGObject* __new_CIdentityKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CIdentityKernelNormalizer(): NULL; }
static CSGObject* __new_CCommUlongStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCommUlongStringKernel(): NULL; }
static CSGObject* __new_CSparseSpatialSampleStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSparseSpatialSampleStringKernel(): NULL; }
static CSGObject* __new_CCustomKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCustomKernel(): NULL; }
static CSGObject* __new_CWaveKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWaveKernel(): NULL; }
static CSGObject* __new_CSigmoidKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSigmoidKernel(): NULL; }
static CSGObject* __new_CTanimotoKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTanimotoKernelNormalizer(): NULL; }
static CSGObject* __new_CAUCKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAUCKernel(): NULL; }
static CSGObject* __new_CLocalityImprovedStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLocalityImprovedStringKernel(): NULL; }
static CSGObject* __new_CGaussianShiftKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGaussianShiftKernel(): NULL; }
static CSGObject* __new_CConstKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CConstKernel(): NULL; }
static CSGObject* __new_CPolyMatchWordStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPolyMatchWordStringKernel(): NULL; }
static CSGObject* __new_CInverseMultiQuadricKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CInverseMultiQuadricKernel(): NULL; }
static CSGObject* __new_CSalzbergWordStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSalzbergWordStringKernel(): NULL; }
static CSGObject* __new_CPolyMatchStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPolyMatchStringKernel(): NULL; }
static CSGObject* __new_CMultiquadricKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultiquadricKernel(): NULL; }
static CSGObject* __new_CDiceKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDiceKernelNormalizer(): NULL; }
static CSGObject* __new_CLogKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLogKernel(): NULL; }
static CSGObject* __new_CSpectrumMismatchRBFKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSpectrumMismatchRBFKernel(): NULL; }
static CSGObject* __new_CLinearKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLinearKernel(): NULL; }
static CSGObject* __new_CAvgDiagKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CAvgDiagKernelNormalizer(): NULL; }
static CSGObject* __new_CDiagKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDiagKernel(): NULL; }
static CSGObject* __new_CRegulatoryModulesStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CRegulatoryModulesStringKernel(): NULL; }
static CSGObject* __new_CPyramidChi2(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPyramidChi2(): NULL; }
static CSGObject* __new_CWeightedDegreeRBFKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWeightedDegreeRBFKernel(): NULL; }
static CSGObject* __new_CBesselKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CBesselKernel(): NULL; }
static CSGObject* __new_CSimpleLocalityImprovedStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSimpleLocalityImprovedStringKernel(): NULL; }
static CSGObject* __new_CLocalAlignmentStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLocalAlignmentStringKernel(): NULL; }
static CSGObject* __new_CZeroMeanCenterKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CZeroMeanCenterKernelNormalizer(): NULL; }
static CSGObject* __new_CGaussianMatchStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGaussianMatchStringKernel(): NULL; }
static CSGObject* __new_CPolyKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPolyKernel(): NULL; }
static CSGObject* __new_CDistantSegmentsKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDistantSegmentsKernel(): NULL; }
static CSGObject* __new_CMultitaskKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMultitaskKernelNormalizer(): NULL; }
static CSGObject* __new_CCauchyKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCauchyKernel(): NULL; }
static CSGObject* __new_CFirstElementKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CFirstElementKernelNormalizer(): NULL; }
static CSGObject* __new_CMatchWordStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CMatchWordStringKernel(): NULL; }
static CSGObject* __new_CSplineKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSplineKernel(): NULL; }
static CSGObject* __new_CRationalQuadraticKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CRationalQuadraticKernel(): NULL; }
static CSGObject* __new_CGaussianShortRealKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGaussianShortRealKernel(): NULL; }
static CSGObject* __new_CLinearStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLinearStringKernel(): NULL; }
static CSGObject* __new_CWeightedDegreeStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWeightedDegreeStringKernel(): NULL; }
static CSGObject* __new_CHistogramWordStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CHistogramWordStringKernel(): NULL; }
static CSGObject* __new_CTensorProductPairKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTensorProductPairKernel(): NULL; }
static CSGObject* __new_CTStudentKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CTStudentKernel(): NULL; }
static CSGObject* __new_CWeightedDegreePositionStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWeightedDegreePositionStringKernel(): NULL; }
static CSGObject* __new_CANOVAKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CANOVAKernel(): NULL; }
static CSGObject* __new_COligoStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new COligoStringKernel(): NULL; }
static CSGObject* __new_CCommWordStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CCommWordStringKernel(): NULL; }
static CSGObject* __new_CSpectrumRBFKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSpectrumRBFKernel(): NULL; }
static CSGObject* __new_CWeightedCommWordStringKernel(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CWeightedCommWordStringKernel(): NULL; }
static CSGObject* __new_CVarianceKernelNormalizer(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CVarianceKernelNormalizer(): NULL; }
static CSGObject* __new_CNormOne(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CNormOne(): NULL; }
static CSGObject* __new_CDimensionReductionPreprocessor(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CDimensionReductionPreprocessor(): NULL; }
static CSGObject* __new_CPruneVarSubMean(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CPruneVarSubMean(): NULL; }
static CSGObject* __new_CSortUlongString(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSortUlongString(): NULL; }
static CSGObject* __new_CSortWordString(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CSortWordString(): NULL; }
static CSGObject* __new_CLogPlusOne(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CLogPlusOne(): NULL; }
static CSGObject* __new_CRandomFourierGaussPreproc(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CRandomFourierGaussPreproc(): NULL; }
static CSGObject* __new_CModelSelectionParameters(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CModelSelectionParameters(): NULL; }
static CSGObject* __new_CGridSearchModelSelection(EPrimitiveType g) { return g == PT_NOT_GENERIC? new CGridSearchModelSelection(): NULL; }
static CSGObject* __new_CStringFileFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CStringFileFeatures<bool>();
		case PT_CHAR: return new CStringFileFeatures<char>();
		case PT_INT8: return new CStringFileFeatures<int8_t>();
		case PT_UINT8: return new CStringFileFeatures<uint8_t>();
		case PT_INT16: return new CStringFileFeatures<int16_t>();
		case PT_UINT16: return new CStringFileFeatures<uint16_t>();
		case PT_INT32: return new CStringFileFeatures<int32_t>();
		case PT_UINT32: return new CStringFileFeatures<uint32_t>();
		case PT_INT64: return new CStringFileFeatures<int64_t>();
		case PT_UINT64: return new CStringFileFeatures<uint64_t>();
		case PT_FLOAT32: return new CStringFileFeatures<float32_t>();
		case PT_FLOAT64: return new CStringFileFeatures<float64_t>();
		case PT_FLOATMAX: return new CStringFileFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CSparseFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CSparseFeatures<bool>();
		case PT_CHAR: return new CSparseFeatures<char>();
		case PT_INT8: return new CSparseFeatures<int8_t>();
		case PT_UINT8: return new CSparseFeatures<uint8_t>();
		case PT_INT16: return new CSparseFeatures<int16_t>();
		case PT_UINT16: return new CSparseFeatures<uint16_t>();
		case PT_INT32: return new CSparseFeatures<int32_t>();
		case PT_UINT32: return new CSparseFeatures<uint32_t>();
		case PT_INT64: return new CSparseFeatures<int64_t>();
		case PT_UINT64: return new CSparseFeatures<uint64_t>();
		case PT_FLOAT32: return new CSparseFeatures<float32_t>();
		case PT_FLOAT64: return new CSparseFeatures<float64_t>();
		case PT_FLOATMAX: return new CSparseFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CStreamingSimpleFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CStreamingSimpleFeatures<bool>();
		case PT_CHAR: return new CStreamingSimpleFeatures<char>();
		case PT_INT8: return new CStreamingSimpleFeatures<int8_t>();
		case PT_UINT8: return new CStreamingSimpleFeatures<uint8_t>();
		case PT_INT16: return new CStreamingSimpleFeatures<int16_t>();
		case PT_UINT16: return new CStreamingSimpleFeatures<uint16_t>();
		case PT_INT32: return new CStreamingSimpleFeatures<int32_t>();
		case PT_UINT32: return new CStreamingSimpleFeatures<uint32_t>();
		case PT_INT64: return new CStreamingSimpleFeatures<int64_t>();
		case PT_UINT64: return new CStreamingSimpleFeatures<uint64_t>();
		case PT_FLOAT32: return new CStreamingSimpleFeatures<float32_t>();
		case PT_FLOAT64: return new CStreamingSimpleFeatures<float64_t>();
		case PT_FLOATMAX: return new CStreamingSimpleFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CStreamingSparseFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CStreamingSparseFeatures<bool>();
		case PT_CHAR: return new CStreamingSparseFeatures<char>();
		case PT_INT8: return new CStreamingSparseFeatures<int8_t>();
		case PT_UINT8: return new CStreamingSparseFeatures<uint8_t>();
		case PT_INT16: return new CStreamingSparseFeatures<int16_t>();
		case PT_UINT16: return new CStreamingSparseFeatures<uint16_t>();
		case PT_INT32: return new CStreamingSparseFeatures<int32_t>();
		case PT_UINT32: return new CStreamingSparseFeatures<uint32_t>();
		case PT_INT64: return new CStreamingSparseFeatures<int64_t>();
		case PT_UINT64: return new CStreamingSparseFeatures<uint64_t>();
		case PT_FLOAT32: return new CStreamingSparseFeatures<float32_t>();
		case PT_FLOAT64: return new CStreamingSparseFeatures<float64_t>();
		case PT_FLOATMAX: return new CStreamingSparseFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CSimpleFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CSimpleFeatures<bool>();
		case PT_CHAR: return new CSimpleFeatures<char>();
		case PT_INT8: return new CSimpleFeatures<int8_t>();
		case PT_UINT8: return new CSimpleFeatures<uint8_t>();
		case PT_INT16: return new CSimpleFeatures<int16_t>();
		case PT_UINT16: return new CSimpleFeatures<uint16_t>();
		case PT_INT32: return new CSimpleFeatures<int32_t>();
		case PT_UINT32: return new CSimpleFeatures<uint32_t>();
		case PT_INT64: return new CSimpleFeatures<int64_t>();
		case PT_UINT64: return new CSimpleFeatures<uint64_t>();
		case PT_FLOAT32: return new CSimpleFeatures<float32_t>();
		case PT_FLOAT64: return new CSimpleFeatures<float64_t>();
		case PT_FLOATMAX: return new CSimpleFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CStreamingStringFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CStreamingStringFeatures<bool>();
		case PT_CHAR: return new CStreamingStringFeatures<char>();
		case PT_INT8: return new CStreamingStringFeatures<int8_t>();
		case PT_UINT8: return new CStreamingStringFeatures<uint8_t>();
		case PT_INT16: return new CStreamingStringFeatures<int16_t>();
		case PT_UINT16: return new CStreamingStringFeatures<uint16_t>();
		case PT_INT32: return new CStreamingStringFeatures<int32_t>();
		case PT_UINT32: return new CStreamingStringFeatures<uint32_t>();
		case PT_INT64: return new CStreamingStringFeatures<int64_t>();
		case PT_UINT64: return new CStreamingStringFeatures<uint64_t>();
		case PT_FLOAT32: return new CStreamingStringFeatures<float32_t>();
		case PT_FLOAT64: return new CStreamingStringFeatures<float64_t>();
		case PT_FLOATMAX: return new CStreamingStringFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CStringFeatures(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CStringFeatures<bool>();
		case PT_CHAR: return new CStringFeatures<char>();
		case PT_INT8: return new CStringFeatures<int8_t>();
		case PT_UINT8: return new CStringFeatures<uint8_t>();
		case PT_INT16: return new CStringFeatures<int16_t>();
		case PT_UINT16: return new CStringFeatures<uint16_t>();
		case PT_INT32: return new CStringFeatures<int32_t>();
		case PT_UINT32: return new CStringFeatures<uint32_t>();
		case PT_INT64: return new CStringFeatures<int64_t>();
		case PT_UINT64: return new CStringFeatures<uint64_t>();
		case PT_FLOAT32: return new CStringFeatures<float32_t>();
		case PT_FLOAT64: return new CStringFeatures<float64_t>();
		case PT_FLOATMAX: return new CStringFeatures<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CSet(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CSet<bool>();
		case PT_CHAR: return new CSet<char>();
		case PT_INT8: return new CSet<int8_t>();
		case PT_UINT8: return new CSet<uint8_t>();
		case PT_INT16: return new CSet<int16_t>();
		case PT_UINT16: return new CSet<uint16_t>();
		case PT_INT32: return new CSet<int32_t>();
		case PT_UINT32: return new CSet<uint32_t>();
		case PT_INT64: return new CSet<int64_t>();
		case PT_UINT64: return new CSet<uint64_t>();
		case PT_FLOAT32: return new CSet<float32_t>();
		case PT_FLOAT64: return new CSet<float64_t>();
		case PT_FLOATMAX: return new CSet<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CBinaryStream(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CBinaryStream<bool>();
		case PT_CHAR: return new CBinaryStream<char>();
		case PT_INT8: return new CBinaryStream<int8_t>();
		case PT_UINT8: return new CBinaryStream<uint8_t>();
		case PT_INT16: return new CBinaryStream<int16_t>();
		case PT_UINT16: return new CBinaryStream<uint16_t>();
		case PT_INT32: return new CBinaryStream<int32_t>();
		case PT_UINT32: return new CBinaryStream<uint32_t>();
		case PT_INT64: return new CBinaryStream<int64_t>();
		case PT_UINT64: return new CBinaryStream<uint64_t>();
		case PT_FLOAT32: return new CBinaryStream<float32_t>();
		case PT_FLOAT64: return new CBinaryStream<float64_t>();
		case PT_FLOATMAX: return new CBinaryStream<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CDynamicArray(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CDynamicArray<bool>();
		case PT_CHAR: return new CDynamicArray<char>();
		case PT_INT8: return new CDynamicArray<int8_t>();
		case PT_UINT8: return new CDynamicArray<uint8_t>();
		case PT_INT16: return new CDynamicArray<int16_t>();
		case PT_UINT16: return new CDynamicArray<uint16_t>();
		case PT_INT32: return new CDynamicArray<int32_t>();
		case PT_UINT32: return new CDynamicArray<uint32_t>();
		case PT_INT64: return new CDynamicArray<int64_t>();
		case PT_UINT64: return new CDynamicArray<uint64_t>();
		case PT_FLOAT32: return new CDynamicArray<float32_t>();
		case PT_FLOAT64: return new CDynamicArray<float64_t>();
		case PT_FLOATMAX: return new CDynamicArray<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CArray2(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CArray2<bool>();
		case PT_CHAR: return new CArray2<char>();
		case PT_INT8: return new CArray2<int8_t>();
		case PT_UINT8: return new CArray2<uint8_t>();
		case PT_INT16: return new CArray2<int16_t>();
		case PT_UINT16: return new CArray2<uint16_t>();
		case PT_INT32: return new CArray2<int32_t>();
		case PT_UINT32: return new CArray2<uint32_t>();
		case PT_INT64: return new CArray2<int64_t>();
		case PT_UINT64: return new CArray2<uint64_t>();
		case PT_FLOAT32: return new CArray2<float32_t>();
		case PT_FLOAT64: return new CArray2<float64_t>();
		case PT_FLOATMAX: return new CArray2<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CCache(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CCache<bool>();
		case PT_CHAR: return new CCache<char>();
		case PT_INT8: return new CCache<int8_t>();
		case PT_UINT8: return new CCache<uint8_t>();
		case PT_INT16: return new CCache<int16_t>();
		case PT_UINT16: return new CCache<uint16_t>();
		case PT_INT32: return new CCache<int32_t>();
		case PT_UINT32: return new CCache<uint32_t>();
		case PT_INT64: return new CCache<int64_t>();
		case PT_UINT64: return new CCache<uint64_t>();
		case PT_FLOAT32: return new CCache<float32_t>();
		case PT_FLOAT64: return new CCache<float64_t>();
		case PT_FLOATMAX: return new CCache<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CArray3(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CArray3<bool>();
		case PT_CHAR: return new CArray3<char>();
		case PT_INT8: return new CArray3<int8_t>();
		case PT_UINT8: return new CArray3<uint8_t>();
		case PT_INT16: return new CArray3<int16_t>();
		case PT_UINT16: return new CArray3<uint16_t>();
		case PT_INT32: return new CArray3<int32_t>();
		case PT_UINT32: return new CArray3<uint32_t>();
		case PT_INT64: return new CArray3<int64_t>();
		case PT_UINT64: return new CArray3<uint64_t>();
		case PT_FLOAT32: return new CArray3<float32_t>();
		case PT_FLOAT64: return new CArray3<float64_t>();
		case PT_FLOATMAX: return new CArray3<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CSimpleFile(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CSimpleFile<bool>();
		case PT_CHAR: return new CSimpleFile<char>();
		case PT_INT8: return new CSimpleFile<int8_t>();
		case PT_UINT8: return new CSimpleFile<uint8_t>();
		case PT_INT16: return new CSimpleFile<int16_t>();
		case PT_UINT16: return new CSimpleFile<uint16_t>();
		case PT_INT32: return new CSimpleFile<int32_t>();
		case PT_UINT32: return new CSimpleFile<uint32_t>();
		case PT_INT64: return new CSimpleFile<int64_t>();
		case PT_UINT64: return new CSimpleFile<uint64_t>();
		case PT_FLOAT32: return new CSimpleFile<float32_t>();
		case PT_FLOAT64: return new CSimpleFile<float64_t>();
		case PT_FLOATMAX: return new CSimpleFile<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CMemoryMappedFile(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CMemoryMappedFile<bool>();
		case PT_CHAR: return new CMemoryMappedFile<char>();
		case PT_INT8: return new CMemoryMappedFile<int8_t>();
		case PT_UINT8: return new CMemoryMappedFile<uint8_t>();
		case PT_INT16: return new CMemoryMappedFile<int16_t>();
		case PT_UINT16: return new CMemoryMappedFile<uint16_t>();
		case PT_INT32: return new CMemoryMappedFile<int32_t>();
		case PT_UINT32: return new CMemoryMappedFile<uint32_t>();
		case PT_INT64: return new CMemoryMappedFile<int64_t>();
		case PT_UINT64: return new CMemoryMappedFile<uint64_t>();
		case PT_FLOAT32: return new CMemoryMappedFile<float32_t>();
		case PT_FLOAT64: return new CMemoryMappedFile<float64_t>();
		case PT_FLOATMAX: return new CMemoryMappedFile<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CArray(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CArray<bool>();
		case PT_CHAR: return new CArray<char>();
		case PT_INT8: return new CArray<int8_t>();
		case PT_UINT8: return new CArray<uint8_t>();
		case PT_INT16: return new CArray<int16_t>();
		case PT_UINT16: return new CArray<uint16_t>();
		case PT_INT32: return new CArray<int32_t>();
		case PT_UINT32: return new CArray<uint32_t>();
		case PT_INT64: return new CArray<int64_t>();
		case PT_UINT64: return new CArray<uint64_t>();
		case PT_FLOAT32: return new CArray<float32_t>();
		case PT_FLOAT64: return new CArray<float64_t>();
		case PT_FLOATMAX: return new CArray<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
static CSGObject* __new_CDecompressString(EPrimitiveType g)
{
	switch (g)
	{
		case PT_BOOL: return new CDecompressString<bool>();
		case PT_CHAR: return new CDecompressString<char>();
		case PT_INT8: return new CDecompressString<int8_t>();
		case PT_UINT8: return new CDecompressString<uint8_t>();
		case PT_INT16: return new CDecompressString<int16_t>();
		case PT_UINT16: return new CDecompressString<uint16_t>();
		case PT_INT32: return new CDecompressString<int32_t>();
		case PT_UINT32: return new CDecompressString<uint32_t>();
		case PT_INT64: return new CDecompressString<int64_t>();
		case PT_UINT64: return new CDecompressString<uint64_t>();
		case PT_FLOAT32: return new CDecompressString<float32_t>();
		case PT_FLOAT64: return new CDecompressString<float64_t>();
		case PT_FLOATMAX: return new CDecompressString<floatmax_t>();
		case PT_SGOBJECT: return NULL;
	}
	return NULL;
}
typedef CSGObject* (*new_sgserializable_t)(EPrimitiveType generic);
typedef struct
{
	const char* m_class_name;
	new_sgserializable_t m_new_sgserializable;
} class_list_entry_t;

static class_list_entry_t class_list[] = {
{m_class_name: "ChebyshewMetric", m_new_sgserializable: __new_CChebyshewMetric},
{m_class_name: "MinkowskiMetric", m_new_sgserializable: __new_CMinkowskiMetric},
{m_class_name: "ChiSquareDistance", m_new_sgserializable: __new_CChiSquareDistance},
{m_class_name: "CanberraWordDistance", m_new_sgserializable: __new_CCanberraWordDistance},
{m_class_name: "CustomDistance", m_new_sgserializable: __new_CCustomDistance},
{m_class_name: "JensenMetric", m_new_sgserializable: __new_CJensenMetric},
{m_class_name: "GeodesicMetric", m_new_sgserializable: __new_CGeodesicMetric},
{m_class_name: "AttenuatedEuclidianDistance", m_new_sgserializable: __new_CAttenuatedEuclidianDistance},
{m_class_name: "HammingWordDistance", m_new_sgserializable: __new_CHammingWordDistance},
{m_class_name: "EuclidianDistance", m_new_sgserializable: __new_CEuclidianDistance},
{m_class_name: "CanberraMetric", m_new_sgserializable: __new_CCanberraMetric},
{m_class_name: "TanimotoDistance", m_new_sgserializable: __new_CTanimotoDistance},
{m_class_name: "ManhattanMetric", m_new_sgserializable: __new_CManhattanMetric},
{m_class_name: "BrayCurtisDistance", m_new_sgserializable: __new_CBrayCurtisDistance},
{m_class_name: "ManhattanWordDistance", m_new_sgserializable: __new_CManhattanWordDistance},
{m_class_name: "KernelDistance", m_new_sgserializable: __new_CKernelDistance},
{m_class_name: "CosineDistance", m_new_sgserializable: __new_CCosineDistance},
{m_class_name: "SparseEuclidianDistance", m_new_sgserializable: __new_CSparseEuclidianDistance},
{m_class_name: "HMM", m_new_sgserializable: __new_CHMM},
{m_class_name: "LinearHMM", m_new_sgserializable: __new_CLinearHMM},
{m_class_name: "Histogram", m_new_sgserializable: __new_CHistogram},
{m_class_name: "GHMM", m_new_sgserializable: __new_CGHMM},
{m_class_name: "PositionalPWM", m_new_sgserializable: __new_CPositionalPWM},
{m_class_name: "KernelPerceptron", m_new_sgserializable: __new_CKernelPerceptron},
{m_class_name: "KNN", m_new_sgserializable: __new_CKNN},
{m_class_name: "GaussianNaiveBayes", m_new_sgserializable: __new_CGaussianNaiveBayes},
{m_class_name: "MKLOneClass", m_new_sgserializable: __new_CMKLOneClass},
{m_class_name: "MKLClassification", m_new_sgserializable: __new_CMKLClassification},
{m_class_name: "MKLMultiClass", m_new_sgserializable: __new_CMKLMultiClass},
{m_class_name: "Perceptron", m_new_sgserializable: __new_CPerceptron},
{m_class_name: "MultiClassSVM", m_new_sgserializable: __new_CMultiClassSVM},
{m_class_name: "GNPPLib", m_new_sgserializable: __new_CGNPPLib},
{m_class_name: "SVMLin", m_new_sgserializable: __new_CSVMLin},
{m_class_name: "DomainAdaptationSVM", m_new_sgserializable: __new_CDomainAdaptationSVM},
{m_class_name: "LaRank", m_new_sgserializable: __new_CLaRank},
{m_class_name: "MPDSVM", m_new_sgserializable: __new_CMPDSVM},
{m_class_name: "ScatterSVM", m_new_sgserializable: __new_CScatterSVM},
{m_class_name: "SGDQN", m_new_sgserializable: __new_CSGDQN},
{m_class_name: "WDSVMOcas", m_new_sgserializable: __new_CWDSVMOcas},
{m_class_name: "SVMLightOneClass", m_new_sgserializable: __new_CSVMLightOneClass},
{m_class_name: "LibSVMMultiClass", m_new_sgserializable: __new_CLibSVMMultiClass},
{m_class_name: "GPBTSVM", m_new_sgserializable: __new_CGPBTSVM},
{m_class_name: "SVMOcas", m_new_sgserializable: __new_CSVMOcas},
{m_class_name: "SubGradientSVM", m_new_sgserializable: __new_CSubGradientSVM},
{m_class_name: "SVMSGD", m_new_sgserializable: __new_CSVMSGD},
{m_class_name: "LibSVM", m_new_sgserializable: __new_CLibSVM},
{m_class_name: "GMNPLib", m_new_sgserializable: __new_CGMNPLib},
{m_class_name: "GMNPSVM", m_new_sgserializable: __new_CGMNPSVM},
{m_class_name: "LibSVMOneClass", m_new_sgserializable: __new_CLibSVMOneClass},
{m_class_name: "QPBSVMLib", m_new_sgserializable: __new_CQPBSVMLib},
{m_class_name: "SVMLight", m_new_sgserializable: __new_CSVMLight},
{m_class_name: "SVM", m_new_sgserializable: __new_CSVM},
{m_class_name: "GNPPSVM", m_new_sgserializable: __new_CGNPPSVM},
{m_class_name: "PluginEstimate", m_new_sgserializable: __new_CPluginEstimate},
{m_class_name: "AveragedPerceptron", m_new_sgserializable: __new_CAveragedPerceptron},
{m_class_name: "Subset", m_new_sgserializable: __new_CSubset},
{m_class_name: "HashedWDFeaturesTransposed", m_new_sgserializable: __new_CHashedWDFeaturesTransposed},
{m_class_name: "SNPFeatures", m_new_sgserializable: __new_CSNPFeatures},
{m_class_name: "ExplicitSpecFeatures", m_new_sgserializable: __new_CExplicitSpecFeatures},
{m_class_name: "PolyFeatures", m_new_sgserializable: __new_CPolyFeatures},
{m_class_name: "ImplicitWeightedSpecFeatures", m_new_sgserializable: __new_CImplicitWeightedSpecFeatures},
{m_class_name: "TOPFeatures", m_new_sgserializable: __new_CTOPFeatures},
{m_class_name: "SparsePolyFeatures", m_new_sgserializable: __new_CSparsePolyFeatures},
{m_class_name: "Labels", m_new_sgserializable: __new_CLabels},
{m_class_name: "WDFeatures", m_new_sgserializable: __new_CWDFeatures},
{m_class_name: "HashedWDFeatures", m_new_sgserializable: __new_CHashedWDFeatures},
{m_class_name: "Alphabet", m_new_sgserializable: __new_CAlphabet},
{m_class_name: "CombinedFeatures", m_new_sgserializable: __new_CCombinedFeatures},
{m_class_name: "RealFileFeatures", m_new_sgserializable: __new_CRealFileFeatures},
{m_class_name: "DummyFeatures", m_new_sgserializable: __new_CDummyFeatures},
{m_class_name: "CombinedDotFeatures", m_new_sgserializable: __new_CCombinedDotFeatures},
{m_class_name: "FKFeatures", m_new_sgserializable: __new_CFKFeatures},
{m_class_name: "LBPPyrDotFeatures", m_new_sgserializable: __new_CLBPPyrDotFeatures},
{m_class_name: "KMeans", m_new_sgserializable: __new_CKMeans},
{m_class_name: "Hierarchical", m_new_sgserializable: __new_CHierarchical},
{m_class_name: "KernelMachine", m_new_sgserializable: __new_CKernelMachine},
{m_class_name: "LinearMachine", m_new_sgserializable: __new_CLinearMachine},
{m_class_name: "PlifMatrix", m_new_sgserializable: __new_CPlifMatrix},
{m_class_name: "Plif", m_new_sgserializable: __new_CPlif},
{m_class_name: "PlifArray", m_new_sgserializable: __new_CPlifArray},
{m_class_name: "DynProg", m_new_sgserializable: __new_CDynProg},
{m_class_name: "IntronList", m_new_sgserializable: __new_CIntronList},
{m_class_name: "SegmentLoss", m_new_sgserializable: __new_CSegmentLoss},
{m_class_name: "ListElement", m_new_sgserializable: __new_CListElement},
{m_class_name: "List", m_new_sgserializable: __new_CList},
{m_class_name: "Time", m_new_sgserializable: __new_CTime},
{m_class_name: "StreamingFile", m_new_sgserializable: __new_CStreamingFile},
{m_class_name: "BinaryFile", m_new_sgserializable: __new_CBinaryFile},
{m_class_name: "Compressor", m_new_sgserializable: __new_CCompressor},
{m_class_name: "BitString", m_new_sgserializable: __new_CBitString},
{m_class_name: "StreamingFileFromSimpleFeatures", m_new_sgserializable: __new_CStreamingFileFromSimpleFeatures},
{m_class_name: "AsciiFile", m_new_sgserializable: __new_CAsciiFile},
{m_class_name: "Math", m_new_sgserializable: __new_CMath},
{m_class_name: "IOBuffer", m_new_sgserializable: __new_CIOBuffer},
{m_class_name: "StreamingAsciiFile", m_new_sgserializable: __new_CStreamingAsciiFile},
{m_class_name: "Signal", m_new_sgserializable: __new_CSignal},
{m_class_name: "StreamingFileFromFeatures", m_new_sgserializable: __new_CStreamingFileFromFeatures},
{m_class_name: "DynamicArrayPtr", m_new_sgserializable: __new_CDynamicArrayPtr},
{m_class_name: "SerializableAsciiFile", m_new_sgserializable: __new_CSerializableAsciiFile},
{m_class_name: "Hash", m_new_sgserializable: __new_CHash},
{m_class_name: "MeanSquaredError", m_new_sgserializable: __new_CMeanSquaredError},
{m_class_name: "StratifiedCrossValidationSplitting", m_new_sgserializable: __new_CStratifiedCrossValidationSplitting},
{m_class_name: "PRCEvaluation", m_new_sgserializable: __new_CPRCEvaluation},
{m_class_name: "ROCEvaluation", m_new_sgserializable: __new_CROCEvaluation},
{m_class_name: "ContingencyTableEvaluation", m_new_sgserializable: __new_CContingencyTableEvaluation},
{m_class_name: "AccuracyMeasure", m_new_sgserializable: __new_CAccuracyMeasure},
{m_class_name: "ErrorRateMeasure", m_new_sgserializable: __new_CErrorRateMeasure},
{m_class_name: "BALMeasure", m_new_sgserializable: __new_CBALMeasure},
{m_class_name: "WRACCMeasure", m_new_sgserializable: __new_CWRACCMeasure},
{m_class_name: "F1Measure", m_new_sgserializable: __new_CF1Measure},
{m_class_name: "CrossCorrelationMeasure", m_new_sgserializable: __new_CCrossCorrelationMeasure},
{m_class_name: "RecallMeasure", m_new_sgserializable: __new_CRecallMeasure},
{m_class_name: "PrecisionMeasure", m_new_sgserializable: __new_CPrecisionMeasure},
{m_class_name: "SpecificityMeasure", m_new_sgserializable: __new_CSpecificityMeasure},
{m_class_name: "MulticlassAccuracy", m_new_sgserializable: __new_CMulticlassAccuracy},
{m_class_name: "CrossValidation", m_new_sgserializable: __new_CCrossValidation},
{m_class_name: "MKLRegression", m_new_sgserializable: __new_CMKLRegression},
{m_class_name: "LibSVR", m_new_sgserializable: __new_CLibSVR},
{m_class_name: "SVRLight", m_new_sgserializable: __new_CSVRLight},
{m_class_name: "HistogramIntersectionKernel", m_new_sgserializable: __new_CHistogramIntersectionKernel},
{m_class_name: "Node", m_new_sgserializable: __new_CNode},
{m_class_name: "Taxonomy", m_new_sgserializable: __new_CTaxonomy},
{m_class_name: "MultitaskKernelTreeNormalizer", m_new_sgserializable: __new_CMultitaskKernelTreeNormalizer},
{m_class_name: "SNPStringKernel", m_new_sgserializable: __new_CSNPStringKernel},
{m_class_name: "MultitaskKernelMaskNormalizer", m_new_sgserializable: __new_CMultitaskKernelMaskNormalizer},
{m_class_name: "CircularKernel", m_new_sgserializable: __new_CCircularKernel},
{m_class_name: "FixedDegreeStringKernel", m_new_sgserializable: __new_CFixedDegreeStringKernel},
{m_class_name: "CombinedKernel", m_new_sgserializable: __new_CCombinedKernel},
{m_class_name: "SphericalKernel", m_new_sgserializable: __new_CSphericalKernel},
{m_class_name: "ExponentialKernel", m_new_sgserializable: __new_CExponentialKernel},
{m_class_name: "PowerKernel", m_new_sgserializable: __new_CPowerKernel},
{m_class_name: "SqrtDiagKernelNormalizer", m_new_sgserializable: __new_CSqrtDiagKernelNormalizer},
{m_class_name: "MultitaskKernelMaskPairNormalizer", m_new_sgserializable: __new_CMultitaskKernelMaskPairNormalizer},
{m_class_name: "Chi2Kernel", m_new_sgserializable: __new_CChi2Kernel},
{m_class_name: "GaussianKernel", m_new_sgserializable: __new_CGaussianKernel},
{m_class_name: "WaveletKernel", m_new_sgserializable: __new_CWaveletKernel},
{m_class_name: "ScatterKernelNormalizer", m_new_sgserializable: __new_CScatterKernelNormalizer},
{m_class_name: "DistanceKernel", m_new_sgserializable: __new_CDistanceKernel},
{m_class_name: "MultitaskKernelPlifNormalizer", m_new_sgserializable: __new_CMultitaskKernelPlifNormalizer},
{m_class_name: "RidgeKernelNormalizer", m_new_sgserializable: __new_CRidgeKernelNormalizer},
{m_class_name: "IdentityKernelNormalizer", m_new_sgserializable: __new_CIdentityKernelNormalizer},
{m_class_name: "CommUlongStringKernel", m_new_sgserializable: __new_CCommUlongStringKernel},
{m_class_name: "SparseSpatialSampleStringKernel", m_new_sgserializable: __new_CSparseSpatialSampleStringKernel},
{m_class_name: "CustomKernel", m_new_sgserializable: __new_CCustomKernel},
{m_class_name: "WaveKernel", m_new_sgserializable: __new_CWaveKernel},
{m_class_name: "SigmoidKernel", m_new_sgserializable: __new_CSigmoidKernel},
{m_class_name: "TanimotoKernelNormalizer", m_new_sgserializable: __new_CTanimotoKernelNormalizer},
{m_class_name: "AUCKernel", m_new_sgserializable: __new_CAUCKernel},
{m_class_name: "LocalityImprovedStringKernel", m_new_sgserializable: __new_CLocalityImprovedStringKernel},
{m_class_name: "GaussianShiftKernel", m_new_sgserializable: __new_CGaussianShiftKernel},
{m_class_name: "ConstKernel", m_new_sgserializable: __new_CConstKernel},
{m_class_name: "PolyMatchWordStringKernel", m_new_sgserializable: __new_CPolyMatchWordStringKernel},
{m_class_name: "InverseMultiQuadricKernel", m_new_sgserializable: __new_CInverseMultiQuadricKernel},
{m_class_name: "SalzbergWordStringKernel", m_new_sgserializable: __new_CSalzbergWordStringKernel},
{m_class_name: "PolyMatchStringKernel", m_new_sgserializable: __new_CPolyMatchStringKernel},
{m_class_name: "MultiquadricKernel", m_new_sgserializable: __new_CMultiquadricKernel},
{m_class_name: "DiceKernelNormalizer", m_new_sgserializable: __new_CDiceKernelNormalizer},
{m_class_name: "LogKernel", m_new_sgserializable: __new_CLogKernel},
{m_class_name: "SpectrumMismatchRBFKernel", m_new_sgserializable: __new_CSpectrumMismatchRBFKernel},
{m_class_name: "LinearKernel", m_new_sgserializable: __new_CLinearKernel},
{m_class_name: "AvgDiagKernelNormalizer", m_new_sgserializable: __new_CAvgDiagKernelNormalizer},
{m_class_name: "DiagKernel", m_new_sgserializable: __new_CDiagKernel},
{m_class_name: "RegulatoryModulesStringKernel", m_new_sgserializable: __new_CRegulatoryModulesStringKernel},
{m_class_name: "PyramidChi2", m_new_sgserializable: __new_CPyramidChi2},
{m_class_name: "WeightedDegreeRBFKernel", m_new_sgserializable: __new_CWeightedDegreeRBFKernel},
{m_class_name: "BesselKernel", m_new_sgserializable: __new_CBesselKernel},
{m_class_name: "SimpleLocalityImprovedStringKernel", m_new_sgserializable: __new_CSimpleLocalityImprovedStringKernel},
{m_class_name: "LocalAlignmentStringKernel", m_new_sgserializable: __new_CLocalAlignmentStringKernel},
{m_class_name: "ZeroMeanCenterKernelNormalizer", m_new_sgserializable: __new_CZeroMeanCenterKernelNormalizer},
{m_class_name: "GaussianMatchStringKernel", m_new_sgserializable: __new_CGaussianMatchStringKernel},
{m_class_name: "PolyKernel", m_new_sgserializable: __new_CPolyKernel},
{m_class_name: "DistantSegmentsKernel", m_new_sgserializable: __new_CDistantSegmentsKernel},
{m_class_name: "MultitaskKernelNormalizer", m_new_sgserializable: __new_CMultitaskKernelNormalizer},
{m_class_name: "CauchyKernel", m_new_sgserializable: __new_CCauchyKernel},
{m_class_name: "FirstElementKernelNormalizer", m_new_sgserializable: __new_CFirstElementKernelNormalizer},
{m_class_name: "MatchWordStringKernel", m_new_sgserializable: __new_CMatchWordStringKernel},
{m_class_name: "SplineKernel", m_new_sgserializable: __new_CSplineKernel},
{m_class_name: "RationalQuadraticKernel", m_new_sgserializable: __new_CRationalQuadraticKernel},
{m_class_name: "GaussianShortRealKernel", m_new_sgserializable: __new_CGaussianShortRealKernel},
{m_class_name: "LinearStringKernel", m_new_sgserializable: __new_CLinearStringKernel},
{m_class_name: "WeightedDegreeStringKernel", m_new_sgserializable: __new_CWeightedDegreeStringKernel},
{m_class_name: "HistogramWordStringKernel", m_new_sgserializable: __new_CHistogramWordStringKernel},
{m_class_name: "TensorProductPairKernel", m_new_sgserializable: __new_CTensorProductPairKernel},
{m_class_name: "TStudentKernel", m_new_sgserializable: __new_CTStudentKernel},
{m_class_name: "WeightedDegreePositionStringKernel", m_new_sgserializable: __new_CWeightedDegreePositionStringKernel},
{m_class_name: "ANOVAKernel", m_new_sgserializable: __new_CANOVAKernel},
{m_class_name: "OligoStringKernel", m_new_sgserializable: __new_COligoStringKernel},
{m_class_name: "CommWordStringKernel", m_new_sgserializable: __new_CCommWordStringKernel},
{m_class_name: "SpectrumRBFKernel", m_new_sgserializable: __new_CSpectrumRBFKernel},
{m_class_name: "WeightedCommWordStringKernel", m_new_sgserializable: __new_CWeightedCommWordStringKernel},
{m_class_name: "VarianceKernelNormalizer", m_new_sgserializable: __new_CVarianceKernelNormalizer},
{m_class_name: "NormOne", m_new_sgserializable: __new_CNormOne},
{m_class_name: "DimensionReductionPreprocessor", m_new_sgserializable: __new_CDimensionReductionPreprocessor},
{m_class_name: "PruneVarSubMean", m_new_sgserializable: __new_CPruneVarSubMean},
{m_class_name: "SortUlongString", m_new_sgserializable: __new_CSortUlongString},
{m_class_name: "SortWordString", m_new_sgserializable: __new_CSortWordString},
{m_class_name: "LogPlusOne", m_new_sgserializable: __new_CLogPlusOne},
{m_class_name: "RandomFourierGaussPreproc", m_new_sgserializable: __new_CRandomFourierGaussPreproc},
{m_class_name: "ModelSelectionParameters", m_new_sgserializable: __new_CModelSelectionParameters},
{m_class_name: "GridSearchModelSelection", m_new_sgserializable: __new_CGridSearchModelSelection},
{m_class_name: "StringFileFeatures", m_new_sgserializable: __new_CStringFileFeatures},
{m_class_name: "SparseFeatures", m_new_sgserializable: __new_CSparseFeatures},
{m_class_name: "StreamingSimpleFeatures", m_new_sgserializable: __new_CStreamingSimpleFeatures},
{m_class_name: "StreamingSparseFeatures", m_new_sgserializable: __new_CStreamingSparseFeatures},
{m_class_name: "SimpleFeatures", m_new_sgserializable: __new_CSimpleFeatures},
{m_class_name: "StreamingStringFeatures", m_new_sgserializable: __new_CStreamingStringFeatures},
{m_class_name: "StringFeatures", m_new_sgserializable: __new_CStringFeatures},
{m_class_name: "Set", m_new_sgserializable: __new_CSet},
{m_class_name: "BinaryStream", m_new_sgserializable: __new_CBinaryStream},
{m_class_name: "DynamicArray", m_new_sgserializable: __new_CDynamicArray},
{m_class_name: "Array2", m_new_sgserializable: __new_CArray2},
{m_class_name: "Cache", m_new_sgserializable: __new_CCache},
{m_class_name: "Array3", m_new_sgserializable: __new_CArray3},
{m_class_name: "SimpleFile", m_new_sgserializable: __new_CSimpleFile},
{m_class_name: "MemoryMappedFile", m_new_sgserializable: __new_CMemoryMappedFile},
{m_class_name: "Array", m_new_sgserializable: __new_CArray},
{m_class_name: "DecompressString", m_new_sgserializable: __new_CDecompressString},	{m_class_name: NULL, m_new_sgserializable: NULL}
};

CSGObject* shogun::new_sgserializable(const char* sgserializable_name,
						   EPrimitiveType generic)
{
	for (class_list_entry_t* i=class_list; i->m_class_name != NULL;
		 i++)
	{
		if (strncmp(i->m_class_name, sgserializable_name, STRING_LEN) == 0)
			return i->m_new_sgserializable(generic);
	}

	return NULL;
}
