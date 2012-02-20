supportedFeatures <- function() {
  names(.feature.map)
}

matchFeatureType <- function(ftype) {
  match.arg(ftype, supportedFeatures())
}

matchFeatureClassToType <- function(fclass) {
  fclean <- gsub("Sparse", "", fclass, ignore.case=TRUE)
  known.classes <- sapply(.feature.map, '[[', 'class')
  idx <- which(fclean ==  known.classes)
  if (length(idx) != 1L) {
    stop("Can't match feature class ", fclass, " to feature type")
  }
  names(.feature.map)[idx]
}

initTrainingFeatures <- function(x, kernel, scaled=scaled, ...) {
  
}