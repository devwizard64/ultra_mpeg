#include <ultra64.h>
#include "internal.h"

balign OSThread piThread;
balign u64 piThreadStack[0x1000/sizeof(u64)];
balign OSMesgQueue piEventQueue;
balign OSMesg piEventBuf[1];

OSDevMgr __osPiDevMgr = {0};
