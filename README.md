# ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
Copyright (C) 2020  devwizard

This project is licensed under the terms of the MIT license.  See `LICENSE` for
more information.

## Using the demo
1. Clone this repository: `git clone --recursive
  https://github.com/devwizard64/ultra_mpeg.git`.
2. If you wish to use libmpeg2, download it here:
  https://libmpeg2.sourceforge.io/downloads.html and place its contents in
  `libmpeg2/`.
3. Install ffmpeg: `apt install ffmpeg`.
4. Install a MIPS cross compiler: `apt install gcc-mips-linux-gnu`.
  * If you are using a toolchain other than `mips-linux-gnu`, edit
    `build_env.sh` accordingly.
5. Download armips: https://github.com/Kingcom/armips/releases and
   place `armips` or `armips.exe` in `tools/`.
6. Place an English SM64 ROM in `donor/UNSME0.z64`.
7. Place a video in `mpg/demo.mp4`.
8. Run `build_mpg.sh`.

## Using in another project
* Add `-I` and `-L` flags according to `build_env.sh`.
* Add `-l mpeg2 -l mpeg2_convert` flags.
* Include `umpg.c` in your project, and add `-D _UMPG_PL_MPEG` or
  `-D _UMPG_LIBMPEG2` flags.
* Include the following functions in your codebase:
  * `malloc`
  * `free`
  * `memset`
  * `osCreateMesgQueue`
  * `osRecvMesg`
  * `osInvalDCache`
  * `osPiStartDma`
  * `fopen` (pl_mpeg / may be stubbed)
  * `fseek` (pl_mpeg / may be stubbed)
  * `ftell` (pl_mpeg / may be stubbed)
  * `fclose` (pl_mpeg / may be stubbed)
  * `fread` (pl_mpeg / may be stubbed)
  * `realloc` (pl_mpeg)
  * `abs` (pl_mpeg)
  * `memmove` (pl_mpeg)
  * `osSetEventMesg` (pl_mpeg)
  * `osSendMesg` (pl_mpeg)
  * `osWritebackDCacheAll` (pl_mpeg)
  * `osGetTime` (pl_mpeg)
  * `osAiSetFrequency` (pl_mpeg)
  * `osAiSetNextBuffer` (pl_mpeg)
  * `memcmp` (libmpeg2)
  * `osSetTimer` (libmpeg2)
* To use `mem.c`:
  * Call `mem_init` to erase any linked heap area
  * Call `mem_link` to add an area of memory to its heap area.  You may call
    this as many times as needed.

## Documentation
* `struct umpg_t *umpg_init(
    s16 x, s16 y, u16 w, u16 h, const void *start, const void *end
);`
  * Create an ultra_mpeg object.
  * `x`: X position of output, 10.2
  * `y`: Y position of output, 10.2
  * `w`: Width of output, 10.2
  * `h`: Height of output, 10.2
  * `start`: ROM start of MPG data
  * `end`: ROM end of MPG data
* `void umpg_free(struct umpg_t *umpg);`
  * Free an ultra_mpeg object.
  * `umpg`: ultra_mpeg object
* `bool umpg_update(struct umpg_t *umpg, Gfx **gfx);`
  * Update an ultra_mpeg object.
  * `umpg`: ultra_mpeg object
  * `gfx`: Buffer to write 3 display list commands.
* `void umpg_resize(struct umpg_t *umpg, s16 x, s16 y, u16 w, u16 h);`
  * Resize an ultra_mpeg object.
  * `umpg`: ultra_mpeg object
  * `x`: X position of output, 10.2
  * `y`: Y position of output, 10.2
  * `w`: Width of output, 10.2
  * `h`: Height of output, 10.2
