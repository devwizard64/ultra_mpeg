/******************************************************************************
 *        ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64        *
 *                    Copyright (C) 2020 - 2022  devwizard                    *
 *     This project is licensed under the terms of the MIT license.  See      *
 *     LICENSE for more information.                                          *
 ******************************************************************************/

#include <stdio.h>

FILE *fopen(const char *pathname, const char *mode)
{
    (void)pathname;
    (void)mode;
    return NULL;
}

int fseek(FILE *stream, long offset, int whence)
{
    (void)stream;
    (void)offset;
    (void)whence;
    return 0;
}

long ftell(FILE *stream)
{
    (void)stream;
    return 0;
}

int fclose(FILE *stream)
{
    (void)stream;
    return 0;
}

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)
{
    (void)ptr;
    (void)size;
    (void)nmemb;
    (void)stream;
    return 0;
}
