#         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
#                     Copyright (C) 2020 - 2022  devwizard
#      This project is licensed under the terms of the MIT license.  See
#      LICENSE for more information.
.set gp=64
.globl _start
_start:
    la      $8, _codeSegmentBssStart
    la      $9, _codeSegmentBssEnd
0:
    add     $8, 16
    sd      $0, -16($8)
    sd      $0, -8($8)
    bne     $8, $9, 0b
    la      $sp, stack_entry-16
    j       entry
