#include <ultra64.h>
#include "internal.h"

balign OSMesg piAccessBuf[1];
balign OSMesgQueue __osPiAccessQueue;

dalign u32 __osPiAccessQueueEnabled = 0;
