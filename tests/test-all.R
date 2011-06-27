library(testthat)
library(shikken)

if (!Sys.getenv('SHIKKEN_TESTDATA_BASE')) {
  Sys.setenv(SHIKKEN_TESTDATA_BASE=system.file("test-data", package="shikken"))
}

test_package("shikken")

