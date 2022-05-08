#include <ultra64.h>
#include "internal.h"

__OSViContext vi[2] = {0};
dalign __OSViContext *__osViCurr = &vi[0];
dalign __OSViContext *__osViNext = &vi[1];
dalign u32 osViNtscEnabled = 1;
dalign u32 osViClock = 48681812;
