#!/bin/sh
test -z "$1" || cd $1
for p in *.patch; do patch -N -t -p1 -i $p || exit 1; done
