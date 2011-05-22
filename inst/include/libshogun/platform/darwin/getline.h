#ifndef __DARWIN_GETLINE_H__
#define __DARWIN_GETLINE_H__

#ifdef DARWIN

#include <stdio.h>   /* flockfile, getc_unlocked, funlockfile */
#include <stdlib.h>  /* malloc, realloc */
#include <errno.h>   /* errno */
#include <unistd.h>  /* ssize_t */

ssize_t getline(char **lineptr, size_t *n, FILE *stream);

#endif

#endif
