;         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
;                        Copyright (C) 2020  devwizard
;      This project is licensed under the terms of the MIT license.  See
;      LICENSE for more information.

.definelabel seg_main_start,            0x00001000
.definelabel main_start,                0x80246000

.definelabel profiler_update,           0x80246050
.definelabel scheduler_main,            0x802469B8
.definelabel video_gfx_start_cimg,      0x802473C8
.definelabel video_gfx_end,             0x80247D14
.definelabel video_init,                0x80247F08
.definelabel video_end,                 0x80248090
.definelabel app_main,                  0x80248AF0
.definelabel mem_dma_read,              0x80278504
.definelabel mem_init_main2,            0x80278974
.definelabel video_gfx,                 0x8033B06C

.definelabel osCreateMesgQueue,         0x803225A0
.definelabel osSetEventMesg,            0x803225D0
.definelabel osRecvMesg,                0x80322800
.definelabel osSendMesg,                0x80322C20
.definelabel osWritebackDCacheAll,      0x80322F40
.definelabel osViBlack,                 0x80323340
.definelabel osInvalDCache,             0x803243B0
.definelabel osPiStartDma,              0x80324460
.definelabel bzero,                     0x80324570
.definelabel osGetTime,                 0x80325070
.definelabel osAiSetFrequency,          0x80325970
.definelabel osAiSetNextBuffer,         0x80325DB0
.definelabel memcpy,                    0x803273F0
.definelabel osSetTimer,                0x80328A10
