#include <ultra64.h>
#include "internal.h"

__OSThreadTail __osThreadTail = {NULL, -1};
dalign OSThread *__osRunQueue = (OSThread *)&__osThreadTail;
dalign OSThread *__osActiveQueue = (OSThread *)&__osThreadTail;
dalign OSThread *__osRunningThread = NULL;
dalign OSThread *__osFaultedThread = NULL;
