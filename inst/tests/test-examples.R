context("Shogun Examples")

test_that("gaussian 'dummy' examples translates correctly", {
  ## http://www.shogun-toolbox.org/doc/developer_tutorial.html
  set = subset(iris, Species == 'setosa')
  ver = subset(iris, Species == 'versicolor')
  idat = rbind(set, ver)
  ix = as.matrix(idat[,1:4])
  iy = as.numeric(idat$Species)
  iy[iy == 2] <- -1
  shikken:::initShikken()
  ip = .Call("gaussian_kernel_example", ix, dim(ix), iy, PACKAGE="shikken")
  ip.y = sign(ip)
  table(iy, ip.y)
})
