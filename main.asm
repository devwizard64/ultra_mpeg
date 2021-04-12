;         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
;                        Copyright (C) 2020  devwizard
;      This project is licensed under the terms of the MIT license.  See
;      LICENSE for more information.

.open "donor/UNSME0.z64", _DST, 0
.include "include/ultra64.asm"
.include "include/sm64.asm"

.definelabel code_demo_start,                                   0x80000400

.orga 0x00000020
.ascii _LABEL

.orga main_start
.base code_main_start

.org debug_update
mem_init_demo:
    la      a0, code_demo_start
    la      a1, demo_start
    la.u    a2, demo_end
    j       mem_dma_read
    la.l    a2, demo_end
.org mem_init_main2
.skip 0x98
    j       mem_init_demo

.org scheduler_main
.skip 0x24
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

.org video_init
.skip 0x68
    jal     video_gfx_cimg
    nop

.org video_end
.skip 0xB4
    nop
    nop
    nop
    nop
    nop
    nop

.org app_main
.skip 0x44
    jal     demo_init
    addiu   ra, ra, @@end-@@start
@@start:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
@@end:
    sw      v0, 0x0024(sp)
    jal     osViBlack
    li      a0, 0
.skip 0x64
    jal     demo_update
    lw      a0, 0x0024(sp)
    nop

.orga 0x00114750
.seg demo_start
.base code_demo_start
.importobj _BUILD + "/main.o"
.align 0x10
heap_start:
.seg demo_end

.seg mpg_demo_start
.incbin _BUILD + "/mpg/demo.mpg"
.seg mpg_demo_end

.close
