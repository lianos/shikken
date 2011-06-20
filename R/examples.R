gaussianExample <- function(x, y) {
  # initShikken()
  # on.exit(exitShikken())
  # 
  .Call("gaussian_kernel_example", x, dim(x), y, PACKAGE="shikken")
}
