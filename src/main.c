/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <unistd.h>
#include <ultra64.h>
#include "gfx.h"
#include "umpg.h"

extern const char _mpgSegmentRomStart[];
extern const char _mpgSegmentRomEnd[];
extern char _gfxSegmentBssEnd[];
extern void malloc_init(void);

extern u64 stack_idle[];
extern u64 stack_app[];

extern u16 gfx_cimg[3][SCREEN_HT][SCREEN_WD];
extern u64 gfx_fifo[FIFO_LEN];
extern u64 gfx_stack[SP_DRAM_STACK_SIZE64];
extern Gfx gfx_data[2][GFX_LEN];

static OSThread thread_idle;
static OSThread thread_app;
static OSMesgQueue pi_mq;
static OSMesgQueue cp_mq;
static OSMesg pi_msg[4];
static OSMesg cp_msg[2];

static OSTask gfx_task;
static UMPG *umpg;

static void gfx_init(void)
{
    gfx_task.t.type = M_GFXTASK;
    gfx_task.t.ucode_boot = rspbootTextStart;
    gfx_task.t.ucode_boot_size =
        (char *)rspbootTextEnd - (char *)rspbootTextStart;
    gfx_task.t.ucode = gspFast3D_fifoTextStart;
    gfx_task.t.ucode_size = SP_UCODE_SIZE;
    gfx_task.t.ucode_data = gspFast3D_fifoDataStart;
    gfx_task.t.ucode_data_size = SP_UCODE_DATA_SIZE;
    gfx_task.t.dram_stack = gfx_stack;
    gfx_task.t.dram_stack_size = sizeof(gfx_stack);
    gfx_task.t.output_buff = gfx_fifo;
    gfx_task.t.output_buff_size = gfx_fifo + FIFO_LEN;
}

static void *gfx_update(void)
{
    static u8 ci;
    static u8 di;
    void *cimg = gfx_cimg[ci];
    void *data = gfx_data[di];
    Gfx *gfx = data;
    if (++ci == 3) ci = 0;
    di ^= 1;
    gDPPipeSync(gfx++);
    gDPSetColorImage(gfx++, G_IM_FMT_RGBA, G_IM_SIZ_16b, SCREEN_WD, cimg);
    gDPSetScissor(gfx++, G_SC_NON_INTERLACE, 0, 0, SCREEN_WD, SCREEN_HT);
    gSPSetOtherMode(
        gfx++, G_SETOTHERMODE_H, 0, 24,
        G_PM_1PRIMITIVE |
        G_CYC_1CYCLE |
        G_TP_PERSP |
        G_TD_CLAMP |
        G_TL_TILE |
        G_TT_NONE |
        G_TF_BILERP |
        G_TC_FILT |
        G_CK_NONE |
        G_CD_MAGICSQ |
        G_AD_DISABLE |
        15
    );
    gSPSetOtherMode(
        gfx++, G_SETOTHERMODE_L, 0, 32,
        G_RM_OPA_SURF | G_RM_OPA_SURF2 |
        G_ZS_PIXEL |
        G_AC_NONE
    );
    umpg_update(umpg, &gfx);
    gDPFullSync(gfx++);
    gSPEndDisplayList(gfx++);
    gfx_task.t.data_ptr = data;
    osWritebackDCacheAll();
    return cimg;
}

static void app_main(void *arg)
{
    void *cimg;
    void *next;
    (void)arg;
    osCreatePiManager(OS_PRIORITY_PIMGR, &pi_mq, pi_msg, 4);
    osCreateMesgQueue(&cp_mq, cp_msg, 2);
    osSetEventMesg(OS_EVENT_SP, &cp_mq, (OSMesg)0);
    osSetEventMesg(OS_EVENT_DP, &cp_mq, (OSMesg)0);
    brk(_gfxSegmentBssEnd);
    malloc_init();
    umpg = umpg_init(
        4*0, 4*0, 4*SCREEN_WD, 4*SCREEN_HT,
        _mpgSegmentRomStart, _mpgSegmentRomEnd
    );
    gfx_init();
    cimg = gfx_update();
    osSpTaskStart(&gfx_task);
    for (;;)
    {
        next = gfx_update();
        osRecvMesg(&cp_mq, NULL, OS_MESG_BLOCK);
        osRecvMesg(&cp_mq, NULL, OS_MESG_BLOCK);
        osSpTaskStart(&gfx_task);
        osViSwapBuffer(cimg);
        osViBlack(FALSE);
        cimg = next;
    }
}

static void idle_main(void *arg)
{
    (void)arg;
    osCreateViManager(OS_PRIORITY_VIMGR);
    osViSetMode(osTvType == OS_TV_NTSC ? &osViModeNtscLan1 : &osViModePalLan1);
    osViBlack(TRUE);
    osViSetSpecialFeatures(
        OS_VI_GAMMA_OFF |
        OS_VI_GAMMA_DITHER_OFF |
        OS_VI_DIVOT_OFF |
        OS_VI_DITHER_FILTER_OFF
    );
    osCreateThread(&thread_app, 2, app_main, NULL, stack_app, 10);
    osStartThread(&thread_app);
    for (;;);
}

void entry(void)
{
    osInitialize();
    osCreateThread(
        &thread_idle, 1, idle_main, NULL, stack_idle, OS_PRIORITY_IDLE
    );
    osStartThread(&thread_idle);
}
