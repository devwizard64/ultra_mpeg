/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <ultra64.h>

int memcmp(const void *s1, const void *s2, size_t n)
{
    const unsigned char *c1 = s1;
    const unsigned char *c2 = s2;
    while (n-- > 0)
    {
        unsigned char a = *c1++;
        unsigned char b = *c2++;
        if (a < b) return -1;
        if (a > b) return +1;
    }
    return 0;
}
