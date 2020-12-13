#         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
#                        Copyright (C) 2020  devwizard
#      This project is licensed under the terms of the MIT license.  See
#      LICENSE for more information.

HOST="mips-linux-gnu"
# -mdivide-breaks
CFLAGS="-march=vr4300 -mfix4300 -mno-abicalls -mno-shared -G 0"
CFLAGS="$CFLAGS -fno-stack-protector -fno-common -fno-PIC -ffreestanding"
CFLAGS="$CFLAGS -fno-builtin -fwrapv"
CC="$HOST-gcc $CFLAGS -Wall -Wextra -Wpedantic
    -I pl_mpeg
    -I libmpeg2/include
    -I include -I $BUILD -I src"
LD="$HOST-ld
    -L libmpeg2/libmpeg2/.libs
    -L libmpeg2/libmpeg2/convert/.libs"
MAIN=""
MKDIR()
{
    if [ ! -d $1 ]
    then
        mkdir $1
    fi
}
CC()
{
    O=$BUILD/src/${1%.*}.o
    $CC "${@:2}" -Ofast -c -o $O src/$1
    MAIN="$MAIN $O"
}
MPG()
{
    O=$BUILD/mpg/${1%.*}.mpg
    if [ ! -f $O ]
    then
        ffmpeg -y -i mpg/$1 "${@:2}" -c:v mpeg1video -c:a mp2 -format mpeg $O
    fi
}
MP2()
{
    O=$BUILD/mpg/${1%.*}.mpg
    if [ ! -f $O ]
    then
        ffmpeg -y -i mpg/$1 "${@:2}" -c:v mpeg2video -c:a mp2 -format mpeg $O
    fi
}
MKDIR build
MKDIR $BUILD
MKDIR $BUILD/mpg
MKDIR $BUILD/src
MKDIR $BUILD/src/stdio
MKDIR $BUILD/src/stdlib
MKDIR $BUILD/src/string
