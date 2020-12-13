/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                       Copyright (C) 2020  devwizard                        *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

.globl memmove
memmove:
    j       memcpy
