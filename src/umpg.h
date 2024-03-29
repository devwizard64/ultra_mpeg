/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#ifndef __UMPG_H__
#define __UMPG_H__

#include <ultra64.h>

typedef struct umpg UMPG;

extern UMPG *umpg_init(
    int x, int y, unsigned int w, unsigned int h,
    const void *start, const void *end
);
extern void umpg_free(UMPG *umpg);
extern int umpg_update(UMPG *umpg, Gfx **gfx);
extern void umpg_resize(
    UMPG *umpg, int x, int y, unsigned int w, unsigned int h
);

#endif /* __UMPG_H__ */
