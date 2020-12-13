/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                       Copyright (C) 2020  devwizard                        *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#ifndef _SM64_H_
#define _SM64_H_

#include <ultra64.h>

/* 0x802473C8 */ extern void video_gfx_start_cimg(void);
/* 0x80247D14 */ extern void video_gfx_end(void);

/* 0x8033B06C */ extern Gfx *video_gfx;

#endif /* _SM64_H_ */
