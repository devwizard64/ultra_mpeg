#include <ultra64.h>
#include "internal.h"

balign OSMesg siAccessBuf[1];
balign OSMesgQueue __osSiAccessQueue;

dalign u32 __osSiAccessQueueEnabled = 0;
