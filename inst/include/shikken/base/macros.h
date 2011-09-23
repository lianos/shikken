#ifndef __SHIKKEN_BASE_MACROS_H__
#define __SHIKKEN_BASE_MACROS_H__

#include <R.h>
#include <Rdefines.h>

#ifdef SHIKKEN_DEBUG
#define SHDEBUG(msg) { Rprintf(msg); }
#else
#define SHDEBUG(msg)
#endif

#endif
