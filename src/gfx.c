/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <ultra64.h>
#include "gfx.h"

u16 gfx_cimg[3][SCREEN_HT][SCREEN_WD];
u64 gfx_fifo[FIFO_LEN];
u64 gfx_stack[SP_DRAM_STACK_SIZE64];
Gfx gfx_data[2][GFX_LEN];
