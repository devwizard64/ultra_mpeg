#ifndef _TYPES_H_
#define _TYPES_H_

#define false   0
#define true    1

#ifndef __ASSEMBLER__

typedef unsigned int uint;

#define lenof(x)        (sizeof((x)) / sizeof((x)[0]))

#ifdef __GNUC__
#define unused          __attribute__((unused))
#else
#define unused
#endif

#endif /* __ASSEMBLER__ */

#endif /* _TYPES_H_ */
