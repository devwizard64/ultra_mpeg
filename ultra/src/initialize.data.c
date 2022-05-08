#include <ultra64.h>
#include "internal.h"

int __osFinalrom;

u64 osClockRate = 62500000;
dalign u32 __osShutdown = 0;
