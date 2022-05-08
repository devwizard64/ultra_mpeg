#ifndef __ULTRA_INTERNAL_H__
#define __ULTRA_INTERNAL_H__

#ifndef __ASSEMBLER__

#ifdef __GNUC__
#define dalign                  __attribute__((aligned(4)))
#define balign                  __attribute__((aligned(8)))
#else
#define dalign
#define balign
#endif

#endif /* __ASSEMBLER__ */

#endif /* __ULTRA_INTERNAL_H__ */
