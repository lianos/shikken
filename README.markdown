shikken is a library for the [R programming language][rlang] that provides
a more idiomatic interface to the [shogun-toolbox][shogun],
a C++ library for "large scale" machine learning.

Please refer to the [shikken project site][shikken] for more information.

The library is currently just a wrapper to the [r_static][r_static] library
that you have to build and install from the command line using by following
[shogun's installation instructions][shogun_install]. This enforces a serious
limitation in the use of the functionality of this library, which is that you
can only build and use one "shogun learning machine" at a time.

The eventual goal is to either work on fixing the `r_modular` interface (which
envolves fixing some [SWIG bugs][swig_bugs]) and to wrap that to make it more
R-friendly, or to have this library call directly into the libshogun library
with Rcpp's help, which [I've got working once before][shikken_lib].

[rlang]: http://www.r-project.org/
[shogun]: http://www.shogun-toolbox.org/
[shikken]: http://lianos.github.com/shikken/
[r_static]: http://shogun-toolbox.org/doc/en/current/r_static_examples.html
[shogun_instal]: http://www.shogun-toolbox.org/doc/en/current/installation.html
[swig_bugs]: http://www.swig.org/Doc2.0/SWIGDocumentation.html#R_nn2
[shikken_lib]: https://github.com/lianos/shikken/tree/master
