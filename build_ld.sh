#         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
#                        Copyright (C) 2020  devwizard
#      This project is licensed under the terms of the MIT license.  See
#      LICENSE for more information.

$LD -r -o $BUILD/main.o $MAIN
tools/armips \
    -strequ _BUILD $BUILD -strequ _LABEL "$LABEL" -strequ _DST $DST -sym $SYM \
    main.asm
tools/crc $DST
