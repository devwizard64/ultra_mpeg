/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                       Copyright (C) 2020  devwizard                        *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#ifndef _ULTRA64_H_
#define _ULTRA64_H_

#ifndef __ASSEMBLER__

/* types.h */
#include <stddef.h>
#include <stdint.h>

typedef  int8_t  s8;
typedef uint8_t  u8;
typedef  int16_t s16;
typedef uint16_t u16;
typedef  int32_t s32;
typedef uint32_t u32;
typedef  int64_t s64;
typedef uint64_t u64;
typedef float    f32;
typedef double   f64;

/* os_thread.h */
typedef s32 OSPri;
typedef s32 OSId;
typedef union {struct {f32 f_odd; f32 f_even;} f; f64 d;} __OSfp;
typedef struct
{
    u64     at, v0, v1, a0, a1, a2, a3;
    u64 t0, t1, t2, t3, t4, t5, t6, t7;
    u64 s0, s1, s2, s3, s4, s5, s6, s7;
    u64 t8, t9,         gp, sp, s8, ra;
    u64 lo, hi;
    u32 sr, pc, cause, badvaddr, rcp;
    u32 fpcsr;
    __OSfp  fp0,  fp2,  fp4,  fp6,  fp8, fp10, fp12, fp14;
    __OSfp fp16, fp18, fp20, fp22, fp24, fp26, fp28, fp30;
}
__OSThreadContext;
typedef struct OSThread_s
{
    struct OSThread_s  *next;
    OSPri               priority;
    struct OSThread_s **queue;
    struct OSThread_s  *tlnext;
    u16                 state;
    u16                 flags;
    OSId                id;
    s32                 fp;
    __OSThreadContext   context;
}
OSThread;

/* os_message.h */
#define OS_EVENT_SW1            0x00
#define OS_EVENT_SW2            0x01
#define OS_EVENT_CART           0x02
#define OS_EVENT_COUNTER        0x03
#define OS_EVENT_SP             0x04
#define OS_EVENT_SI             0x05
#define OS_EVENT_AI             0x06
#define OS_EVENT_VI             0x07
#define OS_EVENT_PI             0x08
#define OS_EVENT_DP             0x09
#define OS_EVENT_CPU_BREAK      0x0A
#define OS_EVENT_SP_BREAK       0x0B
#define OS_EVENT_FAULT          0x0C
#define OS_EVENT_THREADSTATUS   0x0D
#define OS_EVENT_PRENMI         0x0E
#define OS_NUM_EVENTS           0x0F
#define OS_MESG_NOBLOCK         0x00
#define OS_MESG_BLOCK           0x01
typedef u32 OSEvent;
typedef void *OSMesg;
typedef struct OSMesgQueue_s
{
    OSThread           *mtqueue;
    OSThread           *fullqueue;
    s32                 validCount;
    s32                 first;
    s32                 msgCount;
    OSMesg             *msg;
}
OSMesgQueue;

/* os_pi.h */
#define OS_READ                 0x00
#define OS_WRITE                0x01
#define OS_MESG_PRI_NORMAL      0x00
#define OS_MESG_PRI_HIGH        0x01
typedef struct
{
    u16                 type;
    u8                  pri;
    u8                  status;
    OSMesgQueue        *retQueue;
}
OSIoMesgHdr;
typedef struct
{
    OSIoMesgHdr         hdr;
    void               *dramAddr;
    u32                 devAddr;
    u32                 size;
    void               *piHandle;
}
OSIoMesg;

/* os_time.h */
typedef u64 OSTime;
typedef struct OSTimer_s
{
    struct OSTimer_s   *next;
    struct OSTimer_s   *prev;
    OSTime              interval;
    OSTime              value;
    OSMesgQueue        *mq;
    OSMesg              msg;
}
OSTimer;

/* mbi.h */
#define _SHIFTL(v, s, w)        ((u32)(((u32)(v) & ((0x01 << (w)) - 1)) << (s)))
#define _SHIFTR(v, s, w)        ((u32)(((u32)(v) >> (s)) & ((0x01 << (w)) - 1)))
#define G_OFF                   0x00
#define G_ON                    0x01
/* gbi.h */
#define G_DL                    0x06
#define G_ENDDL                 0xB8
#define G_RDPHALF_1             0xB3
#define G_RDPHALF_2             0xB2
#define G_SETTIMG               0xFD
#define G_SETCOMBINE            0xFC
#define G_SETTILE               0xF5
#define G_LOADTILE              0xF4
#define G_SETTILESIZE           0xF2
#define G_RDPSETOTHERMODE       0xEF
#define G_SETSCISSOR            0xED
#define G_SETCONVERT            0xEC
#define G_RDPTILESYNC           0xE8
#define G_RDPPIPESYNC           0xE7
#define G_RDPLOADSYNC           0xE6
#define G_TEXRECT               0xE4
#define G_TEXTURE_IMAGE_FRAC    2
#define G_TX_RENDERTILE         0
#define G_TX_NOMIRROR           0
#define G_TX_CLAMP              2
#define G_TX_NOMASK             0
#define G_TX_NOLOD              0
#define G_IM_FMT_YUV            1
#define G_IM_SIZ_16b            2
#define G_CCMUX_TEXEL0          1
#define G_CCMUX_TEXEL1          2
#define G_CCMUX_K4              7
#define G_CCMUX_K5              15
#define G_CCMUX_0               31
#define G_ACMUX_TEXEL0          1
#define G_ACMUX_SHADE           4
#define G_ACMUX_0               7
#define G_CC_DECALRGBA          0, 0, 0, TEXEL0, 0, 0, 0, TEXEL0
#define G_CC_1CYUV2RGB          TEXEL0, K4, K5, TEXEL0, 0, 0, 0, SHADE
#define G_CC_YUV2RGB            TEXEL1, K4, K5, TEXEL1, 0, 0, 0, 0
#define G_MDSFT_ALPHACOMPARE    0
#define G_MDSFT_ZSRCSEL         2
#define G_MDSFT_RENDERMODE      3
#define G_MDSFT_BLENDER         16
#define G_MDSFT_BLENDMASK       0
#define G_MDSFT_ALPHADITHER     4
#define G_MDSFT_RGBDITHER       6
#define G_MDSFT_COMBKEY         8
#define G_MDSFT_TEXTCONV        9
#define G_MDSFT_TEXTFILT        12
#define G_MDSFT_TEXTLUT         14
#define G_MDSFT_TEXTLOD         16
#define G_MDSFT_TEXTDETAIL      17
#define G_MDSFT_TEXTPERSP       19
#define G_MDSFT_CYCLETYPE       20
#define G_MDSFT_COLORDITHER     22
#define G_MDSFT_PIPELINE        23
#define G_AD_DISABLE            (3 << G_MDSFT_ALPHADITHER)
#define G_CD_MAGICSQ            (0 << G_MDSFT_RGBDITHER)
#define G_CK_NONE               (0 << G_MDSFT_COMBKEY)
#define G_TC_CONV               (0 << G_MDSFT_TEXTCONV)
#define G_TC_FILTCONV           (5 << G_MDSFT_TEXTCONV)
#define G_TF_POINT              (0 << G_MDSFT_TEXTFILT)
#define G_TF_AVERAGE            (3 << G_MDSFT_TEXTFILT)
#define G_TT_NONE               (0 << G_MDSFT_TEXTLUT)
#define G_TL_TILE               (0 << G_MDSFT_TEXTLOD)
#define G_TD_CLAMP              (0 << G_MDSFT_TEXTDETAIL)
#define G_TP_NONE               (0 << G_MDSFT_TEXTPERSP)
#define G_CYC_1CYCLE            (0 << G_MDSFT_CYCLETYPE)
#define G_CYC_2CYCLE            (1 << G_MDSFT_CYCLETYPE)
#define G_PM_NPRIMITIVE         (0 << G_MDSFT_PIPELINE)
#define G_AC_NONE               (0 << G_MDSFT_ALPHACOMPARE)
#define G_ZS_PIXEL              (0 << G_MDSFT_ZSRCSEL)
#define CVG_DST_CLAMP           0x0000
#define ZMODE_OPA               0x0000
#define FORCE_BL                0x4000
#define G_BL_CLR_IN             0
#define G_BL_1                  2
#define G_BL_0                  3
#define GBL_c1(m1a, m1b, m2a, m2b)                                             \
    (m1a) << 30 | (m1b) << 26 | (m2a) << 22 | (m2b) << 18
#define GBL_c2(m1a, m1b, m2a, m2b)                                             \
    (m1a) << 28 | (m1b) << 24 | (m2a) << 20 | (m2b) << 16
#define RM_OPA_SURF(clk)                                                       \
    CVG_DST_CLAMP | FORCE_BL | ZMODE_OPA |                                     \
    GBL_c##clk(G_BL_CLR_IN, G_BL_0, G_BL_CLR_IN, G_BL_1)
#define G_RM_OPA_SURF           RM_OPA_SURF(1)
#define G_RM_OPA_SURF2          RM_OPA_SURF(2)
#define G_RM_PASS               GBL_c1(G_BL_CLR_IN, G_BL_0, G_BL_CLR_IN, G_BL_1)
#define G_CV_K0                 175
#define G_CV_K1                 -43
#define G_CV_K2                 -89
#define G_CV_K3                 222
#define G_CV_K4                 114
#define G_CV_K5                 42
#define G_SC_NON_INTERLACE      0
#define G_DL_PUSH               0x00
#define gSPDisplayList(pkt, dl)                                                \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 = _SHIFTL(G_DL, 24, 8) | _SHIFTL(G_DL_PUSH, 16, 8);           \
    _g->words.w1 = (u32)(dl);                                                  \
}
#define gSPEndDisplayList(pkt)                                                 \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 = _SHIFTL(G_ENDDL, 24, 8);                                    \
    _g->words.w1 = 0;                                                          \
}
#define gsSPEndDisplayList()    {{_SHIFTL(G_ENDDL, 24, 8), 0}}
#define gSPTextureRectangle(pkt, xl, yl, xh, yh, tile, s, t, dsdx, dtdy)       \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g[0].words.w0 =                                                           \
        _SHIFTL(G_TEXRECT,   24,  8) |                                         \
        _SHIFTL(xh,          12, 12) |                                         \
        _SHIFTL(yh,           0, 12);                                          \
    _g[0].words.w1 =                                                           \
        _SHIFTL(tile,        24,  3) |                                         \
        _SHIFTL(xl,          12, 12) |                                         \
        _SHIFTL(yl,           0, 12);                                          \
    _g[1].words.w0 =                                                           \
        _SHIFTL(G_RDPHALF_1, 24,  8);                                          \
    _g[1].words.w1 =                                                           \
        _SHIFTL(s,           16, 16) |                                         \
        _SHIFTL(t,            0, 16);                                          \
    _g[2].words.w0 =                                                           \
        _SHIFTL(G_RDPHALF_2, 24,  8);                                          \
    _g[2].words.w1 =                                                           \
        _SHIFTL(dsdx,        16, 16) |                                         \
        _SHIFTL(dtdy,         0, 16);                                          \
    (pkt);                                                                     \
    (pkt);                                                                     \
}
#define gDPSetTextureImage(pkt, fmt, siz, width, i)                            \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 =                                                             \
        _SHIFTL(G_SETTIMG, 24,  8) |                                           \
        _SHIFTL(fmt,       21,  3) |                                           \
        _SHIFTL(siz,       19,  2) |                                           \
        _SHIFTL((width)-1,  0, 12);                                            \
    _g->words.w1 = (u32)(i);                                                   \
}
#define gsDPSetCombineLERP(                                                    \
    a0, b0, c0, d0, Aa0, Ab0, Ac0, Ad0, a1, b1, c1, d1, Aa1, Ab1, Ac1, Ad1     \
)                                                                              \
{{                                                                             \
    _SHIFTL(G_SETCOMBINE,  24,  8) |                                           \
    _SHIFTL(G_CCMUX_## a0, 20,  4) |                                           \
    _SHIFTL(G_CCMUX_## c0, 15,  5) |                                           \
    _SHIFTL(G_ACMUX_##Aa0, 12,  3) |                                           \
    _SHIFTL(G_ACMUX_##Ac0,  9,  3) |                                           \
    _SHIFTL(G_CCMUX_## a1,  5,  4) |                                           \
    _SHIFTL(G_CCMUX_## c1,  0,  5),                                            \
    _SHIFTL(G_CCMUX_## b0, 28,  4) |                                           \
    _SHIFTL(G_CCMUX_## d0, 15,  3) |                                           \
    _SHIFTL(G_ACMUX_##Ab0, 12,  3) |                                           \
    _SHIFTL(G_ACMUX_##Ad0,  9,  3) |                                           \
    _SHIFTL(G_CCMUX_## b1, 24,  4) |                                           \
    _SHIFTL(G_ACMUX_##Aa1, 21,  3) |                                           \
    _SHIFTL(G_ACMUX_##Ac1, 18,  3) |                                           \
    _SHIFTL(G_CCMUX_## d1,  6,  3) |                                           \
    _SHIFTL(G_ACMUX_##Ab1,  3,  3) |                                           \
    _SHIFTL(G_ACMUX_##Ad1,  0,  3),                                            \
}}
#define gsDPSetCombineMode(a, b)        gsDPSetCombineLERP(a, b)
#define gsDPSetOtherMode(mode0, mode1)                                         \
    {{_SHIFTL(G_RDPSETOTHERMODE, 24, 8) | _SHIFTL(mode0, 0, 24), (u32)(mode1)}}
#define gDPSetTileSize(pkt, tile, uls, ult, lrs, lrt)                          \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 =                                                             \
        _SHIFTL(G_SETTILESIZE, 24,  8) |                                       \
        _SHIFTL(uls,           12, 12) |                                       \
        _SHIFTL(ult,            0, 12);                                        \
    _g->words.w1 =                                                             \
        _SHIFTL(tile,          24,  3) |                                       \
        _SHIFTL(lrs,           12, 12) |                                       \
        _SHIFTL(lrt,            0, 12);                                        \
}
#define gDPLoadTile(pkt, tile, uls, ult, lrs, lrt)                             \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 =                                                             \
        _SHIFTL(G_LOADTILE, 24,  8) |                                          \
        _SHIFTL(uls,        12, 12) |                                          \
        _SHIFTL(ult,         0, 12);                                           \
    _g->words.w1 =                                                             \
        _SHIFTL(tile,       24,  3) |                                          \
        _SHIFTL(lrs,        12, 12) |                                          \
        _SHIFTL(lrt,         0, 12);                                           \
}
#define gsDPSetTile(                                                           \
    fmt, siz, line, tmem, tile, palette, cmt, maskt, shiftt, cms, masks,       \
    shifts                                                                     \
)                                                                              \
{{                                                                             \
    _SHIFTL(G_SETTILE, 24,  8) |                                               \
    _SHIFTL(fmt,       21,  3) |                                               \
    _SHIFTL(siz,       19,  2) |                                               \
    _SHIFTL(line,       9,  9) |                                               \
    _SHIFTL(tmem,       0,  9),                                                \
    _SHIFTL(tile,      24,  3) |                                               \
    _SHIFTL(palette,   20,  4) |                                               \
    _SHIFTL(cmt,       18,  2) |                                               \
    _SHIFTL(maskt,     14,  4) |                                               \
    _SHIFTL(shiftt,    10,  4) |                                               \
    _SHIFTL(cms,        8,  2) |                                               \
    _SHIFTL(masks,      4,  4) |                                               \
    _SHIFTL(shifts,     0,  4),                                                \
}}
#define gDPSetScissorFrac(pkt, mode, ulx, uly, lrx, lry)                       \
{                                                                              \
    Gfx *_g = (Gfx *)pkt;                                                      \
    _g->words.w0 =                                                             \
        _SHIFTL(G_SETSCISSOR, 24,  8) |                                        \
        _SHIFTL((int)(ulx),   12, 12) |                                        \
        _SHIFTL((int)(uly),    0, 12);                                         \
    _g->words.w1 =                                                             \
        _SHIFTL(mode,         24,  2) |                                        \
        _SHIFTL((int)(lrx),   12, 12) |                                        \
        _SHIFTL((int)(lry),    0, 12);                                         \
}
#define gsDPSetConvert(k0, k1, k2, k3, k4, k5)                                 \
{{                                                                             \
    _SHIFTL(G_SETCONVERT, 24,  8) |                                            \
    _SHIFTL(k0,           13,  9) |                                            \
    _SHIFTL(k1,            4,  9) |                                            \
    _SHIFTR(k2,            5,  4),                                             \
    _SHIFTL(k2,           27,  5) |                                            \
    _SHIFTL(k3,           18,  9) |                                            \
    _SHIFTL(k4,            9,  9) |                                            \
    _SHIFTL(k5,            0,  9),                                             \
}}
#define gDPPipeSync(pkt)                                                       \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 = _SHIFTL(G_RDPPIPESYNC, 24, 8);                              \
    _g->words.w1 = 0;                                                          \
}
#define gsDPPipeSync()          {{_SHIFTL(G_RDPPIPESYNC, 24, 8), 0}}
#define gDPLoadSync(pkt)                                                       \
{                                                                              \
    Gfx *_g = (Gfx *)(pkt);                                                    \
    _g->words.w0 = _SHIFTL(G_RDPLOADSYNC, 24, 8);                              \
    _g->words.w1 = 0;                                                          \
}
typedef union
{
    struct
    {
        u32 w0;
        u32 w1;
    }
    words;
    u64 force_structure_alignment;
}
Gfx;

/* 0x803225A0 */ extern void osCreateMesgQueue(OSMesgQueue *, OSMesg *, s32);
/* 0x803225D0 */ extern void osSetEventMesg(OSEvent, OSMesgQueue *, OSMesg);
/* 0x80322800 */ extern s32 osRecvMesg(OSMesgQueue *, OSMesg *, s32);
/* 0x80322C20 */ extern void osSendMesg(OSMesgQueue *, OSMesg, s32);
/* 0x80322F40 */ extern void osWritebackDCacheAll(void);
/* 0x803243B0 */ extern void osInvalDCache(void *, s32);
/* 0x80324460 */ extern s32 osPiStartDma(
    OSIoMesg *, s32, s32, u32, void *, u32, OSMesgQueue *
);
/* 0x80324570 */ extern void bzero(void *, u32);
/* 0x80325070 */ extern OSTime osGetTime(void);
/* 0x80325970 */ extern s32 osAiSetFrequency(u32);
/* 0x80325DB0 */ extern s32 osAiSetNextBuffer(void *, u32);
/* 0x803273F0 */ extern void *memcpy(void *, const void *, size_t);
/* 0x80328A10 */ extern s32 osSetTimer(
    OSTimer *, OSTime, OSTime, OSMesgQueue *, OSMesg
);

#endif /* __ASSEMBLER__ */

#endif /* _ULTRA64_H_ */
