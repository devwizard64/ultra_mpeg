/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <ultra64.h>

void *memset(void *s, int c, size_t n)
{
    char *dst = s;
    while (n-- > 0) *dst++ = c;
    return s;
}
