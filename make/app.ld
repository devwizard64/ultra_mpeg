/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#define TEXT(x) x(.text*); . = ALIGN(16);
#define DATA(x) x(.data*); . = ALIGN(16); x(.rodata*); . = ALIGN(16);
#define BSS(x)  x(.bss*);  . = ALIGN(16);
#define SECTION(addr, name, s_text, s_data, s_bss)                      \
    _##name##SegmentRomStart  = __dev;                                  \
    _##name##SegmentStart     = ADDR(.name.text);                       \
    _##name##SegmentTextStart = ADDR(.name.text);                       \
    .name.text (addr)  : AT(__dev) {s_text}                             \
    _##name##SegmentTextEnd   = ADDR(.name.text) + SIZEOF(.name.text);  \
    __dev += SIZEOF(.name.text);                                        \
    _##name##SegmentDataStart = ADDR(.name.data);                       \
    .name.data         : AT(__dev) {s_data}                             \
    _##name##SegmentDataEnd   = ADDR(.name.data) + SIZEOF(.name.data);  \
    __dev += SIZEOF(.name.data);                                        \
    _##name##SegmentBssStart  = ADDR(.name.bss);                        \
    .name.bss (NOLOAD) : AT(__dev) {s_bss}                              \
    _##name##SegmentBssEnd    = ADDR(.name.bss)  + SIZEOF(.name.bss);   \
    _##name##SegmentEnd       = ADDR(.name.bss)  + SIZEOF(.name.bss);   \
    _##name##SegmentRomEnd    = __dev;

stack_entry = 0x80100000;
stack_idle  = 0x800FFC00;
stack_app   = 0x800FF800;

OUTPUT_ARCH(mips)
SECTIONS
{
    .makerom 0x04000000 : AT(0)
    {
        ULTRA/lib/PR/romheader.o(.text);
        . = ALIGN(64);
        ULTRA/lib/PR/Boot.o(.text);
        ULTRA/lib/PR/font.o(.data);
        . = ALIGN(0x1000);
    }
    __dev = 0x1000;
    SECTION(0x80000400, code,
        TEXT(BUILD/code.o)
        TEXT(ULTRA/lib/PR/rspboot.o)
        TEXT(ULTRA/lib/PR/gspFast3D.fifo.o)
        ,
        DATA(BUILD/code.o)
        DATA(ULTRA/lib/PR/rspboot.o)
        DATA(ULTRA/lib/PR/gspFast3D.fifo.o)
        ,
        BSS(BUILD/code.o)
        BSS(ULTRA/lib/PR/rspboot.o)
        BSS(ULTRA/lib/PR/gspFast3D.fifo.o)
    )
    ASSERT(__dev <= 0x00101000, "error: CODE exceeds device size.")
    ASSERT(. <= 0x80100000, "error: CODE exceeds memory size.")
    SECTION(0x80100000, gfx,,, BSS(BUILD/src/gfx.o))
    SECTION(0, mpg,, DATA(BUILD/src/demo.o),)
    memmove = memcpy;
    /DISCARD/ : {*(*)}
}
