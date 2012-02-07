camel2snake <- function(x) {
  mapply(function(x.o, x.split) {
    caps <- grep("[A-Z]", x.split)
    caps <- caps[caps != 1]
    if (length(caps)) {
      val <- character(nchar(x.o) + length(caps))
      idx <- rep(1, nchar(x.o))
      idx[caps] <- 2
      idx <- cumsum(idx)
      val[idx] <- tolower(x.split)
      val[seq(0, length(caps) - 1) + caps] <- '_'
      val <- paste(val, collapse="")
    } else {
      val <- x.o
    }
  }, x, strsplit(x, ''))
}

snake2camel <- function(x) {
  mapply(function(x.o, x.split) {
    under <- x.split == "_"
    ## Don't do anything if _ is at first or last position
    under[c(1, length(under))] <- FALSE
    if (any(under)) {
      idx <- which(under)
      x.split[idx + 1] <- toupper(x.split[idx + 1])
      val <- paste(x.split[-idx], collapse="")
    } else {
      val <- x.o
    }
    val
  }, x, strsplit(x, ''))
}

dir.exists <- function(path){
  path <- as.character(path)
  !is.na(file.info(path)$isdir) && file.info(path)$isdir
}