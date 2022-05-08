.globl aspMainTextStart
aspMainTextStart:
.incbin "build/src/PR/aspMain.text.bin"
.globl aspMainTextEnd
aspMainTextEnd:

.data

.globl aspMainDataStart
aspMainDataStart:
.incbin "build/src/PR/aspMain.data.bin"
.globl aspMainDataEnd
aspMainDataEnd:
