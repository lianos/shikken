## -*- mode: makefile; -*-

#all:	$(SHLIB) userLibrary
all:	libshogun

USERDIR=../inst/lib
USERLIB=libshogun.dynlib
USERLIBST=libshogun.a

###############################################################################
## Stuff define in shoguns .config file
PARTS = libshogun
LIBSHOGUN_DYNAMIC=$(USERLIB)
LIBSHOGUN_STATIC=$(USERLIBST)
# LIBSHOGUN_TARGET=libshogun.10.0.dylib
LIBSHOGUN_SONAME=libshogun.10.dylib
LIBSHOGUN_TARGET=$(USERLIBST)
USE_DOXYGEN=no
EXT_LIB=$(DYLIB_EXT)
EXT_SRC_C=c
EXT_SRC_CPP=cpp
KERNELNAME=Darwin
MACHINE=i386
EXT_OBJ_CPP=cpp.o
EXT_OBJ_C=c.o
EXT_SRC_CPP=cpp
EXT_SRC_C=c
GDB=gdb
COMP_C=gcc
COMP_CPP=g++
#DEFINES=-DSHOGUN -DDARWIN -DHAVE_POWL -DHAVE_SQRTL -DHAVE_LOG2 -DHAVE_HDF5 -DHAVE_XML -DUSE_GZIP -DUSE_BZIP2 -DHAVE_LARGEFILE -DUSE_SHORTREAL_KERNELCACHE -DUSE_HMMPARALLELSTRUCTURES -DUSE_HMMPARALLEL -DUSE_BIGSTATES -DUSE_HMMCACHE -DUSE_REFERENCE_COUNTING -DUSE_SVMLIGHT
DEFINES=-DSHOGUN -DDARWIN -DHAVE_POWL -DHAVE_SQRTL -DHAVE_LOG2 -DHAVE_HDF5 -DUSE_GZIP -DUSE_BZIP2 -DHAVE_LARGEFILE -DUSE_SHORTREAL_KERNELCACHE -DUSE_HMMPARALLELSTRUCTURES -DUSE_HMMPARALLEL -DUSE_BIGSTATES -DUSE_HMMCACHE -DUSE_REFERENCE_COUNTING -DUSE_SVMLIGHT
INCLUDES=-I. -I/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Headers
INCLUDES+=-I../inst/include/libshogun

MAKEDEPEND=g++ -MM
SRCDIR=../inst/include/libshogun

HEADERFILES	= $(shell find $(SRCDIR) -name "*.$(EXT_SRC_HEADER)" )
SRCFILES 	= $(shell find $(SRCDIR) -name "*.$(EXT_SRC_C)" -o -name "*.$(EXT_SRC_CPP)")
OBJFILES 	= $(patsubst %.$(EXT_SRC_CPP),%.$(EXT_OBJ_CPP), \
                     $(patsubst %.$(EXT_SRC_C),%.$(EXT_OBJ_C), $(SRCFILES)))

LINK=g++
PRELINKFLAGS=
LINKFLAGS=
POSTLINKFLAGS=-lm -pthread -lhdf5 -lxml2 -llapack -lcblas -lz -lbz2
POSTLINKCMD=true
LIBSYMLINKCMD=ln -s $(LIBSHOGUN_TARGET) $(LIBSHOGUN_SONAME) ; \
	ln -s $(LIBSHOGUN_TARGET) $(LIBSHOGUN_DYNAMIC) ; \
	ln -s $(LIBSHOGUN_TARGET) $(LIBSHOGUN_SONAME)
COMPFLAGS_C = -fPIC -g -Wall -pthread
COMPFLAGS_CPP = -fPIC -g -pthread

OS=$(shell uname)

###############################################################################
## RCPP stuff
PKG_CXXFLAGS += -I../inst/include -I../inst/include/libshogun -I. -DHAVE_MVEC -DHAVE_LAPACK #
PKG_LIBS +=`$(R_HOME)/bin/Rscript -e "Rcpp:::LdFlags()"` $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)

#userLibrary: $(USERLIB) $(USERLIBST)
# userLibrary:
#   (cd ../inst/include/libshogun; make)

%.$(EXT_OBJ_CPP): %.$(EXT_SRC_CPP)
	$(COMP_CPP) $(COMPFLAGS_CPP) $(DEFINES) -c $(INCLUDES) -o $@ $<

%.$(EXT_OBJ_C): %.$(EXT_SRC_C)
	$(COMP_C) $(COMPFLAGS_C) $(DEFINES) -c $(INCLUDES) -o $@ $<

#libshogun: $(OBJFILES) $(SRCFILES) $(HEADERFILES)
libshogun: .depend $(OBJFILES) $(SRCFILES) $(HEADERFILES)
	g++ -shared -Wl,-dylib_install_name -Wl,$@.so.1 -o $@.so.1.0.1 \
		$(shell find $(SRCDIR) -name "*.$(EXT_OBJ_CPP)" -o \
		-name "*.$(EXT_OBJ_C)" 2>/dev/null) $(LINKFLAGS) $(POSTLINKFLAGS)
    # + if test "$(OS)" = "Darwin" ; then \
    # + $(CXX) -shared -Wl,-dylib_install_name -Wl,$(libname_shared_major_version) -o $@ $(objects) ; \
    # + else \
    #   $(CXX) -shared -Wl,-soname,$(libname_shared_major_version) -o $@ $(objects) ; \

  # g++ $(PRELINKFLAGS) $(INCLUDES) -o $@ $(shell find $(SRCDIR) -name "*.$(EXT_OBJ_CPP)" -o \
  #   -name "*.$(EXT_OBJ_C)" 2>/dev/null) $(LINKFLAGS) $(POSTLINKFLAGS)
  # @$(POSTLINKCMD) $@
  # @$(LIBSYMLINKCMD)

.depend:
	find $(SRCDIR) -name "*.$(EXT_SRC_C)" -o -name "*.$(EXT_SRC_CPP)" \
	-exec $(MAKEDEPEND) $(DEFINES) $(INCLUDES) {} -MT {}.o \; >.depend

## Includes depencies
-include .depend

