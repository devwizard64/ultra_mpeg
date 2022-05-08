#include <ultra64.h>
#include "internal.h"

balign u32 __osContPifRam[0x40/sizeof(u32)];
u8 __osContLastCmd;
u8 __osMaxControllers;
balign OSTimer __osEepromTimer;
balign OSMesgQueue __osEepromTimerQ;
balign OSMesg __osEepromTimerMsg[1];

dalign u32 __osContinitialized = 0;
