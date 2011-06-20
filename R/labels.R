createLables <- function(y, type=c('classification', 'regression'), ...) {
  # n.unique <- length(unique(y))
  # if (is.null(type)) {
  #   ## guess what we want to do
  #   if (is.factor(y) || n.unique == 2) {
  #     type <- 'classification'
  #   } else if (n.unique > 2) {
  #     type <- 'regression'
  #   } else {
  #     stop("Can't guess what type of labels")
  #   }
  # } else {
  #   type <- match.arg(type)
  # }
  # 
  # if (type == 'classification') {
  #   if (length(n.unique) < 2) {
  #     stop("Only two-class classification is supported")
  #   }
  #   if (is.factor(y)) {
  #     ## switch to numeric and save label information
  #   }
  #   
  #   y
  # } else {
  #   
  # }
  # 
  # if (is.null(type)) {
  #   if (is.factor(y)) {
  #     type <- 'classification'
  #   }
  #   type <- 'guess'
  # }
  # label.type <- match.arg(type, c(, 'guess')
  # y <- as.numeric(y)
  # n.unique <- length(unique(y))
  # 
  # if (label.type == 'guess') {
  #   label.type <- if (n.unique > 2) 'regression' else 'classification'
  # }
  # 
  # if (label.type == 'classification') {
  #   
  # }
  NULL
}