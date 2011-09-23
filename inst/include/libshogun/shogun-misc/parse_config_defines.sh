#!/usr/bin/env bash

## This file will read the config.h file generated during a system install of
## the shogun-toolbox in order to generate an appropriate DEFINES variable used
## during compilation of the package.

echo "Reading from file $1"

DEFINES=

cat $1 | while read line
do
    
done
