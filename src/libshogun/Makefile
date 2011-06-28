# note that the word libshogun (all lowercase or all uppercase)
# will be replaced with the current interface name
#
.SUFFIXES: .c .c.o .cpp .cpp.o .h .i .so .dylib .a _wrap.cxx _wrap.cxx.o
.PHONY: all out clean end targets warn2err err2warn ctags buildout buildend dist

SRCDIR = .

all: $(LIBSHOGUN_TARGET) $(OTHER_TARGETS) $(OTHERDEPS)

INCLUDES += $(INCLUDES_LIBSHOGUN)
DEFINES += $(DEFINES_LIBSHOGUN)
COMPFLAGS_CPP += $(DEFINES)
COMPFLAGS_C += $(DEFINES)
LINKFLAGS += $(LINKFLAGS_LIBSHOGUN)
POSTLINKFLAGS += $(POSTLINKFLAGS_LIBSHOGUN)
PRELINKFLAGS += $(PRELINKFLAGS_LIBSHOGUN)

# SRC/OBJFILES lie all in the subdir of SRCDIR
SVNEntries = $(shell find $(SRCDIR) -name entries -type f)
HEADERFILES	= $(shell find $(SRCDIR) -name "*.$(EXT_SRC_HEADER)" )
SRCFILES 	= $(shell find $(SRCDIR) -name "*.$(EXT_SRC_C)" -o -name "*.$(EXT_SRC_CPP)")
CPPTMPFILES	= $(shell find $(SRCDIR) -name "*.$(EXT_CPP_TMP)")
SRCTMPFILES     = $(CPPTMPFILES:.$(EXT_CPP_TMP)=.$(EXT_SRC_CPP))
SRCFILES        += $(SRCTMPFILES)

OBJFILES 	= $(patsubst %.$(EXT_SRC_CPP),%.$(EXT_OBJ_CPP), \
                     $(patsubst %.$(EXT_SRC_C),%.$(EXT_OBJ_C), $(SRCFILES)))

linecount:
	@echo -n "C/C++ source code files (.cpp,.c):"
	@cat $(SRCFILES) | grep -vc '^ *$$'
	@echo -n "C/C++ header files (.h):"
	@cat $(HEADERFILES) | grep -vc '^ *$$'
	@echo -n "SWIG header files (.i):"
	@echo -n "Total:"
	@cat $(SRCFILES) $(HEADERFILES) $(SWIGIFILES) | grep -vc '^ *$$'

targets:
	@echo "=========="
	@echo "=targets:="
	@echo "=========="
	@egrep '^[a-z]+:' Makefile | grep -v '\.o:' | \
		sed -e 's/:.*//g' -e 's/out//g' -e 's/end//g' -e 's/^/     /g' | sort | uniq

distclean: clean
		@rm -f tags .depend

clean:
	@rm -f $(shell find . -name "*.cpp.o" -o -name "*.c.o")
	@rm -f $(shell find . -name "*.a" -o -name "*.so*" -o -name "*.dylib" -o -name "*.dll" -o -name "*~" -o -name ".#*")
	@rm -f $(SRCTMPFILES)
	@rm -f $(LIBSHOGUN_TARGET)

$(OBJFILES): .depend Makefile

$(LIBSHOGUN_STATIC): .depend $(OBJFILES) $(SRCFILES) $(HEADERFILES)
	-ar rcs $@ $(shell find $(SRCDIR) -name "*.$(EXT_OBJ_CPP)" -o \
		-name "*.$(EXT_OBJ_C)" 2>/dev/null)

# %.$(EXT_OBJ_CPP): %.$(EXT_SRC_CPP)
#   $(COMP_CPP) $(COMPFLAGS_CPP) $(DEFINES) -c $(INCLUDES) -o $@ $<
#   @test -f $*.$(EXT_CPP_TMP) && test "$(SRCDIR)" != "." \
#     && rm -f $< || true
# 
# %.$(EXT_OBJ_C): %.$(EXT_SRC_C)
#   $(COMP_C) $(COMPFLAGS_C) $(DEFINES) -c $(INCLUDES) -o $@ $<
# 
# %.$(EXT_SRC_CPP): %.$(EXT_CPP_TMP) %.$(EXT_CPP_SH) $(HEADERFILES)
#   @echo "generating $@ from $*.$(EXT_CPP_TMP) by running $*.$(EXT_CPP_SH)"
#   @echo "/*" > $@
#   @echo " * THIS IS A GENERATED FILE!  DO NOT CHANGE THIS FILE!  CHANGE THE" >> $@
#   @echo " * CORRESPONDING TEMPLAT FILE, PLEASE!" >> $@
#   @echo -e " */\n" >> $@
#   @cat  $< >> $@
#   @sh $*.$(EXT_CPP_SH) $@ $(HEADERFILES)
# 
# %.$(EXT_SRC_CPP): %.$(EXT_CPP_TMP) %.$(EXT_CPP_PY) $(HEADERFILES)
#   @echo "generating $@ from $*.$(EXT_CPP_TMP) by running $*.$(EXT_CPP_PY)"
#   @echo "/*" > $@
#   @echo " * THIS IS A GENERATED FILE!  DO NOT CHANGE THIS FILE!  CHANGE THE" >> $@
#   @echo " * CORRESPONDING TEMPLAT FILE, PLEASE!" >> $@
#   @echo -e " */\n" >> $@
#   @cat  $< >> $@
#   @$(PYTHON) $*.$(EXT_CPP_PY) $@ $(HEADERFILES)

# Do not include dependencies when they are about to be removed anyway.
ifneq ($(MAKECMDGOALS),distclean)
ifneq ($(MAKECMDGOALS),clean)

# Generate dependecies.
.depend:
	find $(SRCDIR) -name "*.$(EXT_SRC_C)" -o -name "*.$(EXT_SRC_CPP)" \
	-exec $(MAKEDEPEND) $(DEFINES) $(INCLUDES) {} -MT {}.o \; >.depend
# ifeq (makedepend,$(MAKEDEPEND))
#   -$(MAKEDEPEND) $(DEFINES) $(INCLUDES) \
#     $(shell find $(SRCDIR) -name "*.$(EXT_SRC_CPP)" ) $(MAKEDEPENDOPTS) | \
#     sed -e 's/\.o:/.$(EXT_OBJ_CPP):/g' >.depend
#   -$(MAKEDEPEND) $(DEFINES) $(INCLUDES) \
#     $(shell find $(SRCDIR) -name "*.$(EXT_SRC_C)" ) $(MAKEDEPENDOPTS) | \
#     sed -e 's/\.o:/.$(EXT_OBJ_C):/g' >>.depend
# else #gcc -MM
#   find $(SRCDIR) -name "*.$(EXT_SRC_C)" -o -name "*.$(EXT_SRC_CPP)" \
#   -exec $(MAKEDEPEND) $(DEFINES) $(INCLUDES) {} -MT {}.o \; >.depend
#   ( find . -name "*.$(EXT_INP_SWIG)" | cut -c 3- ; find ../libshogun/ -name "*.h"  ) | \
#       sed 's#/[/]*#/#g' | \
#       $(PYTHON) ../.generate_link_dependencies.py "$(PRE_LIB_SWIG_LIBSHOGUN)" \
#       "$(EXT_LIB_SWIG_LIBSHOGUN)" $(LIBSHOGUN_MODE) >>.depend
# ifeq (r_modular,$(LIBSHOGUN_TARGET))
#       bash -c "( for i in \`grep '.$(EXT_LIB):' .depend | cut -f 1 -d ':'\` ; \
#       do echo \`echo \$$i | sed s/.$(EXT_LIB)/.R:/\` \$$i ; done ) >>.depend"
# endif
# 
# endif
# 
# # Include dependecies.
# -include .depend
endif
endif
