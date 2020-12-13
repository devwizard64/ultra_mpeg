/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                       Copyright (C) 2020  devwizard                        *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

.globl memset
memset:
    bnez    $a1, 0f
    move    $a1, $a2
    j       bzero
0:
    beqz    $a2, 1f
0:
    sb      $a1, 0x0000($a0)
    addiu   $a0, $a0, 0x0001
    addiu   $a2, $a2, -0x0001
    bnez    $a2, 0b
1:
    jr      $ra
