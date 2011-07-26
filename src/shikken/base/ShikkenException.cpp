#include "shikken/base/ShikkenException.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <R.h>

using namespace shikken;

void ShikkenException::init(const char* str) {
    size_t n = strlen(str) + 1;

    msg = (char*) malloc(n);
    if (msg) {
        strncpy(msg, str, n);
    } else {
        Rf_error("Could not even allocate memory for shikken exception");
    }
}

ShikkenException::ShikkenException(const char* str) {
    init(str);
}

ShikkenException::ShikkenException(const ShikkenException& orig) {
    init(orig.msg);
}

ShikkenException::~ShikkenException() {
    free(msg);
}
