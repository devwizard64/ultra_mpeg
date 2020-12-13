#!/bin/bash

#         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
#                        Copyright (C) 2020  devwizard
#      This project is licensed under the terms of the MIT license.  See
#      LICENSE for more information.

set -e
BUILD=build/mpg
DST=$BUILD/mpg.z64
SYM=$BUILD/mpg.sym
LABEL="ultra_mpeg  pl_mpeg "
source build_env.sh
MPG demo.mp4 -vf scale=160:112 -r 30 -q:v 10 -ac 1 -ar 32000 -b:a 32K
CC stdio/file.S
CC stdlib/realloc.c
CC stdlib/abs.c
CC string/memmove.S
CC string/memset.S
CC mem.c
CC umpg.c -D _UMPG_PL_MPEG
CC demo.c
source build_ld.sh
