/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                       Copyright (C) 2020  devwizard                        *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

.globl memcmp
memcmp:
.set noreorder
    beqzl   $a2, 1f
    li      $v0, 0
.set reorder
0:
    lbu     $2, 0x0000($a0)
    lbu     $3, 0x0000($a1)
    subu    $v0, $2, $3
    bnez    $v0, 1f
    addiu   $a0, $a0, 0x0001
    addiu   $a1, $a1, 0x0001
    addiu   $a2, $a2, -0x0001
    bnez    $a2, 0b
1:
    jr      $ra
