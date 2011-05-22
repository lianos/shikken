#ifdef DARWIN

#include "platform/darwin/getline.h"

/* A "drop in" replacement for GNU/getline, to be used on OSX/BSD  */
/* This function was provided by Jeremy S. Sherman here:           */
/* http://stackoverflow.com/questions/4160353                      */
ssize_t getline(char **linep, size_t *np, FILE *stream)
{
	char *p = NULL;
	size_t i = 0;
	int ch;

	if (!linep || !np) {
		errno = EINVAL;
		return -1;
	}

	if (!(*linep) || !(*np)) {
		*np = 120;
		*linep = (char *)malloc(*np);
		if (!(*linep)) {
			return -1;
		}
	}

	flockfile(stream);

	p = *linep;
	for (ch = 0; (ch = getc_unlocked(stream)) != EOF;) {
		if (i > *np) {
			/* Grow *linep. */
			size_t m = *np * 2;
			char *s = (char *)realloc(*linep, m);

			if (!s) {
				int error = errno;
				funlockfile(stream);
				errno = error;
				return -1;
			}

			*linep = s;
			*np = m;
		}

		p[i] = ch;
		if ('\n' == ch) break;
		i += 1;
	}
	funlockfile(stream);

	/* Null-terminate the string. */
	if (i > *np) {
		/* Grow *linep. */
		size_t m = *np * 2;
		char *s = (char *)realloc(*linep, m);

		if (!s) {
			return -1;
		}

		*linep = s;
		*np = m;
	}

	p[i + 1] = '\0';
	return ((i > 0) ? i : -1);
}

#endif
