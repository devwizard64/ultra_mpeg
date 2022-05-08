/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

static void crc(char *buf, const unsigned char *data, size_t size)
{
    uint32_t c0;
    uint32_t c1;
    uint32_t c0a;
    uint32_t c0b;
    uint32_t c1a;
    uint32_t c1b;
    size_t i;
    c0 = c1 = c0a = c0b = c1a = c1b = 0xF8CA4DDC;
    for (i = 0; i < size; i += 4)
    {
        uint32_t x;
        uint32_t o;
        uint32_t s;
        uint32_t r;
        x = data[i+0] << 24 | data[i+1] << 16 | data[i+2] << 8 | data[i+3];
        o = c0 + x;
        if (o < c0) c0a++;
        s    = x & 0x1F;
        r    = x << s | x >> (32-s);
        c0   = o;
        c0b ^= x;
        c1  += r;
        c1a ^= c1a < x ? c0^x : r;
        c1b += c1^x;
    }
    for (; i < 0x100000; i += 4) c1b += c1;
    c0 ^= c0a^c0b;
    c1 ^= c1a^c1b;
    buf[0] = c0 >> 24;
    buf[1] = c0 >> 16;
    buf[2] = c0 >>  8;
    buf[3] = c0 >>  0;
    buf[4] = c1 >> 24;
    buf[5] = c1 >> 16;
    buf[6] = c1 >>  8;
    buf[7] = c1 >>  0;
}

int main(int argc, char *argv[])
{
    FILE *f;
    unsigned char *data;
    size_t size;
    char buf[0x30];
    if (argc < 2 || argc > 4)
    {
        fprintf(stderr, "usage: %s <image> [code] [label]\n", argv[0]);
        return 1;
    }
    memset(buf, 0, sizeof(buf));
    if (argc > 2)
    {
        memcpy(&buf[0x2B], argv[2], 4);
        buf[0x2F] = strtol(&argv[2][4], NULL, 0);
    }
    if (argc > 3)
    {
        memset(&buf[0x10], ' ', 20);
        size = strlen(argv[3]);
        if (size > 20) size = 20;
        memcpy(&buf[0x10], argv[3], size);
    }
    if ((f = fopen(argv[1], "r+b")) == NULL)
    {
        fprintf(stderr, "error: could not open '%s'\n", argv[1]);
        return 1;
    }
    fseek(f, -0x1000, SEEK_END);
    size = ftell(f);
    if (size > 0x100000) size = 0x100000;
    data = malloc(size);
    fseek(f, 0x1000, SEEK_SET);
    fread(data, 1, size, f);
    crc(&buf[0x00], data, size);
    free(data);
    fseek(f, 0x10, SEEK_SET);
    fwrite(buf, 1, sizeof(buf), f);
    fclose(f);
    return 0;
}
