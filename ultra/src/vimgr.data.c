#include <ultra64.h>
#include "internal.h"

balign OSThread viThread;
balign u64 viThreadStack[0x1000/sizeof(u64)];
balign OSMesgQueue viEventQueue;
balign OSMesg viEventBuf[5];
balign OSIoMesg viRetraceMsg;
balign OSIoMesg viCounterMsg;
u16 viMgrMain__retrace;

OSDevMgr __osViDevMgr = {0};
