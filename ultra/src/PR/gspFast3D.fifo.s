.globl gspFast3D_fifoTextStart
gspFast3D_fifoTextStart:

init_start:
.incbin "build/src/PR/gspFast3D.fifo.init.bin"
.incbin "build/src/PR/gspFast3D.fifo.main.bin", 0x88
init_end:

main_start:
.incbin "build/src/PR/gspFast3D.fifo.main.bin", 0, 0x88
main_end:

clip_start:
.incbin "build/src/PR/gspFast3D.fifo.clip.bin"
clip_end:

light_start:
.incbin "build/src/PR/gspFast3D.fifo.light.bin"
light_end:

exit_start:
.incbin "build/src/PR/gspFast3D.fifo.exit.bin"
exit_end:

.globl gspFast3D_fifoTextEnd
gspFast3D_fifoTextEnd:

.data

.globl gspFast3D_fifoDataStart
gspFast3D_fifoDataStart:

.set DATA, 0

.macro prg name
    .word \name\()_start - gspFast3D_fifoTextStart
    .half \name\()_end - \name\()_start - 1
    .incbin "build/src/PR/gspFast3D.fifo.data.bin", DATA+6, 2
    .set DATA, DATA+8
.endm

prg init
prg main
prg clip
prg light
prg exit

.incbin "build/src/PR/gspFast3D.fifo.data.bin", DATA

.globl gspFast3D_fifoDataEnd
gspFast3D_fifoDataEnd:
