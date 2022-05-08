/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <ultra64.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct mem
{
    struct mem *prev;
    struct mem *next;
    int i;
    size_t size;
}
MEM;

typedef struct blk
{
    MEM *free;
    MEM *used;
}
BLK;

#define NBLK    (23-4)

static BLK mblk[NBLK];

void malloc_init(void)
{
    bzero(mblk, sizeof(mblk));
}

void *malloc(size_t size)
{
    size_t sz = (size+sizeof(MEM)+15) & ~15;
    int i;
    for (i = 0; i < NBLK; i++)
    {
        size_t n = 16 << i;
        if (sz <= n)
        {
            BLK *blk = &mblk[i];
            MEM *mem;
            if (blk->free != NULL)
            {
                mem = blk->free;
                blk->free = mem->prev;
            }
            else
            {
                if ((mem = sbrk(n)) == (void *)-1) goto err;
                mem->prev = NULL;
            }
            mem->prev = blk->used;
            mem->next = NULL;
            mem->i = i;
            mem->size = size;
            if (blk->used != NULL) blk->used->next = mem;
            blk->used = mem;
            return mem+1;
        }
    }
err:
    return NULL;
}

void free(void *ptr)
{
    MEM *mem = (MEM *)ptr-1;
    BLK *blk = &mblk[mem->i];
    if (mem->prev != NULL) mem->prev->next = mem->next;
    if (mem->next != NULL) mem->next->prev = mem->prev;
    mem->prev = blk->free;
    mem->next = NULL;
    if (blk->free != NULL) blk->free->next = mem;
    blk->free = mem;
}

void *realloc(void *ptr, size_t size)
{
    if (ptr != NULL)
    {
        MEM *mem = (MEM *)ptr-1;
        size_t siz = mem->size;
        if (size > siz)
        {
            void *alc;
            if ((alc = malloc(size)) != NULL)
            {
                memcpy(alc, ptr, siz);
                free(ptr);
            }
            return alc;
        }
        mem->size = size;
        return ptr;
    }
    return malloc(size);
}
