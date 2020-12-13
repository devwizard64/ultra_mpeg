#!/bin/bash

#         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
#                        Copyright (C) 2020  devwizard
#      This project is licensed under the terms of the MIT license.  See
#      LICENSE for more information.

set -e
BUILD=build/mp2
DST=$BUILD/mp2.z64
SYM=$BUILD/mp2.sym
LABEL="ultra_mpeg  libmpeg2"
source build_env.sh
if [ ! -f libmpeg2/libmpeg2/.libs/libmpeg2.a ]
then
    cd libmpeg2
    ./configure LIBMPEG2_CFLAGS="$CFLAGS" --host=$HOST --with-pic=no \
        --enable-shared=no --enable-static=no
    make -C libmpeg2 -j8
    cd ..
fi
MP2 demo.mp4 -vf scale=160:112 -r 15 -q:v 10 -an
CC string/memset.S
CC string/memcmp.S
CC mem.c
CC umpg.c -D _UMPG_LIBMPEG2
CC demo.c
MAIN="$MAIN -l mpeg2 -l mpeg2convert"
source build_ld.sh
