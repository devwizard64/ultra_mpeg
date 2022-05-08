#include <ultra64.h>
#include "internal.h"

balign OSTimer __osBaseTimer;
OSTime __osCurrentTime;
u32 __osBaseCounter;
u32 __osViIntrCount;
u32 __osTimerCounter;

dalign OSTimer *__osTimerList = &__osBaseTimer;
