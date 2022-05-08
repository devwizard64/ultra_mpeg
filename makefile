#         ultra_mpeg - An MPEG-1/2 decoder library for the Nintendo 64
#                     Copyright (C) 2020 - 2022  devwizard
#      This project is licensed under the terms of the MIT license.  See
#      LICENSE for more information.

TARGET  ?= mpg
BUILD   := build/$(TARGET)

CODE_OBJ := \
	$(BUILD)/src/crt0.o             \
	$(BUILD)/src/main.o             \
	$(BUILD)/src/umpg.o

LIBC_OBJ := \
	$(BUILD)/src/libc/abs.o         \
	$(BUILD)/src/libc/memset.o      \
	$(BUILD)/src/libc/memcmp.o      \
	$(BUILD)/src/libc/brk.o         \
	$(BUILD)/src/libc/malloc.o      \
	$(BUILD)/src/libc/file.o

CROSS   := mips-linux-gnu

ULTRA   := ultra
TOOLS   := tools
RES != $(MAKE) -C $(ULTRA)
RES != $(MAKE) -C $(TOOLS)

CC      := $(CROSS)-gcc
LD      := $(CROSS)-ld
CPP     := $(CROSS)-cpp
OBJCOPY := $(CROSS)-objcopy
ARCH    := -mabi=32 -march=vr4300 -mfix4300 -mno-abicalls -fno-PIC -G 0
FLAG    := -I$(ULTRA)/include -Ipl_mpeg -Ilibmpeg2/include
OPT     := -Os
WFLAG   := -Wall -Wextra -Wpedantic -Werror=implicit-function-declaration
CCFLAG  := $(ARCH) -mno-check-zero-division -ffreestanding
CCFLAG  += $(FLAG) $(OPT) $(WFLAG)
ASFLAG  := $(ARCH) $(FLAG) $(OPT)
CPPFLAG := $(FLAG) -DULTRA=$(ULTRA) -DBUILD=$(BUILD) -Umips
FFMPEGFLAG  := -vf scale=160:120 -r 30 -q:v 5 -ac 1 -ar 32000 -b:a 32K

ifeq ($(TARGET),mpg)
	CCFLAG  += -DUMPG_PL_MPEG
	LDFLAG  :=
	LIB     :=
else ifeq ($(TARGET),mp2)
	CCFLAG  += -DUMPG_LIBMPEG2
	LDFLAG  := -Llibmpeg2/libmpeg2/.libs -Llibmpeg2/libmpeg2/convert/.libs
	LIB     := -lmpeg2 -lmpeg2convert
else
	$(error invalid target "$(TARGET)")
endif

.PHONY: default
default: $(BUILD)/app.z64

.PHONY: clean
clean:
	rm -f -r build

$(BUILD)/%.z64: $(BUILD)/%.elf
	$(OBJCOPY) -O binary $< $@
	$(TOOLS)/mask $@ NAAE0 "ultra_mpeg  $(TARGET)"

-include $(addsuffix .d,$(basename $(CODE_OBJ) $(BUILD)/src/gfx.o $(BUILD)/src/mpg.o $(LIBC_OBJ)))

$(BUILD)/app.elf: $(BUILD)/code.o $(BUILD)/src/gfx.o $(BUILD)/src/demo.o
$(BUILD)/%.elf: $(BUILD)/make/%.ld
	$(LD) -Map $(@:.elf=.map) -o $@ -T $<

-include $(BUILD)/make/app.d
$(BUILD)/make/app.ld:
$(BUILD)/make/%: make/% | $(BUILD)/make
	$(CPP) $(CPPFLAG) -MMD -MP -MT $@ -P -o $@ $<

build/mp2/code.o: | libmpeg2/libmpeg2/.libs/libmpeg2.a
$(BUILD)/code.o: make/rel.ld $(CODE_OBJ) $(LIBC_OBJ)
	$(LD) -L$(ULTRA)/lib $(LDFLAG) -r -o $@ -T $^ $(LIB) -lultra_rom

$(BUILD)/%.o: %.c
	$(CC) $(CCFLAG) -MMD -MP -c -o $@ $<

$(BUILD)/%.o: %.s
	$(CC) $(ASFLAG) -MMD -MP -c -o $@ $<

build/mp2/%.o: %.mp4
	ffmpeg -y -i $< $(FFMPEGFLAG) -c:v mpeg2video -c:a mp2 -format mpeg $(@:.o=.mpg)
	echo ".data; .incbin \"$(@:.o=.mpg)\"" > $(@:.o=.s)
	$(CC) $(ASFLAG) -c -o $@ $(@:.o=.s)

build/mpg/%.o: %.mp4
	ffmpeg -y -i $< $(FFMPEGFLAG) -c:v mpeg1video -c:a mp2 -format mpeg $(@:.o=.mpg)
	echo ".data; .incbin \"$(@:.o=.mpg)\"" > $(@:.o=.s)
	$(CC) $(ASFLAG) -c -o $@ $(@:.o=.s)

libmpeg2/libmpeg2/.libs/libmpeg2.a:
	cd libmpeg2 && ./configure LIBMPEG2_CFLAGS="$(ARCH) -mno-check-zero-division -ffreestanding $(OPT)" --host=$(CROSS) --with-pic=no --enable-shared=no --enable-static=no
	make -C libmpeg2/libmpeg2

dirs = $(foreach d,$(wildcard $1*),$(call dirs,$d/,$2) $(filter $(subst *,%,$2),$d))
BUILD_OBJ := $(call dirs,src/,*.c *.s)
$(foreach f,$(BUILD_OBJ),$(eval $f: | $(addprefix $(BUILD)/,$(dir $f))))
$(BUILD)/make $(BUILD)/src $(sort $(addprefix $(BUILD)/,$(dir $(BUILD_OBJ)))):
	mkdir -p $@
