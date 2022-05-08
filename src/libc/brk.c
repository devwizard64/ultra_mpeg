/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <ultra64.h>

static char *brkp;

int brk(void *addr)
{
    if (addr > (void *)PHYS_TO_K0(osMemSize)) return -1;
    brkp = addr;
    return 0;
}

void *sbrk(long increment)
{
    void *ptr = brkp;
    if (brk(brkp+increment) != 0) return (void *)-1;
    return ptr;
}
