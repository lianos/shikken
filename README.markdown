This is an R library for the [shogun toolbox][shogun] that provides
a more R-idiomatic interface to the toolbox than the `sg` and `shogun`
(`r` and `r_modular`) libraries that come with the toolbox itself.

I'm hoping this will sidestep the problem the `r_modular` interface has
which is a result of a non-fully functional [R-swig][Rswig].

The layout of this package is inspired by [RcppArmadillo][armadillo], and
the library design is inspired by [kernlab][kernlab].

DISCLAIMER: This is work in progress, so it's probably not a good idea
for *you* to use it just yet.

[shogun]: http://www.shogun-toolbox.org/ "shogun toolbox"
[Rswig]: http://www.swig.org/Doc2.0/R.html#R_nn2
[armadillo]: http://dirk.eddelbuettel.com/code/rcpp.armadillo.html
[kernlab]: http://cran.r-project.org/web/packages/kernlab/
