#include <ultra64.h>
#include "internal.h"

const char _Printf__80339880[] = "hlL";
const char fchar[] = " +-#0";
const u32 fbit[] = {1, 2, 4, 8, 16, 0};

extern void L80326B40(void);
extern void L80326B90(void);
extern void L80326D90(void);
extern void L80326F74(void);
extern void L8032717C(void);
extern void L803272A4(void);
extern void L80327308(void);
extern void L803273A0(void);

void (*const _Putfld__803398A4[])(void) =
{
    L80326F74,
    L803273A0,
    L80326F74,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L80326D90,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L80326B40,
    L80326B90,
    L80326F74,
    L80326F74,
    L80326F74,
    L803273A0,
    L80326B90,
    L803273A0,
    L803273A0,
    L803273A0,
    L803273A0,
    L8032717C,
    L80326D90,
    L803272A4,
    L803273A0,
    L803273A0,
    L80327308,
    L803273A0,
    L80326D90,
    L803273A0,
    L803273A0,
    L80326D90,
};

char spaces[] = "                                ";
char zeroes[] = "00000000000000000000000000000000";
