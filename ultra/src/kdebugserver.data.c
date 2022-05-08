#include <ultra64.h>
#include "internal.h"

balign u8 kdebugserver__buffer[0x100];
balign OSThread __osThreadSave;

dalign u32 debug_state = 0;
dalign u32 numChars = 0;
dalign u32 numCharsToReceive = 0;
