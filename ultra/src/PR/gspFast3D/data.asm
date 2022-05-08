.create "build/src/PR/gspFast3D.fifo.data.bin", 0

    .half 0, 0, 0, prg_init_start
    .half 0, 0, 0, prg_main_start
    .half 0, 0, 0, prg_ext_start
    .half 0, 0, 0, prg_ext_start
    .half 0, 0, 0, prg_ext_start
    .half 4090, -4090
    .half 0x7FFF, 0x0000
    .align 16
    .half 0, 1, 2, -1
    .half 0x4000, 0x0004, 0x0633, 0x0200
    .half 0x7FFF, 0xFFF8, 0x0008, 0x0040, 0x0020, 0x8000, 0x01CC, 0xCCCC
    .half 1, -1, 1, 1, 1, -1, 1, 1
    .half 2, 2, 2, 2, 2, 2, 2, 2
    .word 0x00010000
    .word 0x00000001
    .word 0x00000001
    .word 0x00000001
    .word 0x00010000
    .word 0x0000FFFF
    .word 0x00000001
    .word 0x0000FFFF
    .word 0x00000000
    .word 0x0001FFFF
    .word 0x00000000
    .word 0x00010001
    .half light
    .half 0x7FFF
    .half 0x571D
    .half 0x3A0C
    .half 0x0001, 0x0002, 0x0100, 0x0200, 0x4000, 0x0040
    .half 0
    .half exit
    .word 0x00FFFFFF
    .half case_DMA
    .half cmd_next
    .half case_IMM
    .half case_RDP
    .half cmd_next
    .half case_G_MTX
    .half cmd_next
    .half case_G_MOVEMEM
    .half case_G_VTX
    .half cmd_next
    .half case_G_DL
    .half cmd_next
    .half cmd_next
    .half cmd_next
    .half case_G_RDPHALF_CONT
    .half case_G_RDPHALF_2
    .half case_G_RDPHALF_1
    .half case_G_PERSPNORM
    .half cmd_next
    .half case_G_CLEARGEOMETRYMODE
    .half case_G_SETGEOMETRYMODE
    .half case_G_ENDDL
    .half case_G_SETOTHERMODE_L
    .half case_G_SETOTHERMODE_H
    .half case_G_TEXTURE
    .half case_G_MOVEWORD
    .half case_G_POPMTX
    .half case_G_CULLDL
    .half case_G_TRI1
    .half ProcClipI
    .half ProcClipO
    .half ProcClipFI
    .half ProcClipFO
    .half ProcClipDraw
    .half clip
    .half ProcClipNext
    .half cmd_next_sync
    .half 0
    .word 0
    .word 0
    .align 8
    .byte 0
    .align 2
    .half 0xFFFF
    .align 4
    .half 0
    .byte 0
    .byte 0
    .word 0xEF080CFF
    .word 0x00000000
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .half 0
    .half 0
    .word 0
    .word 0x80000040
    .word 0
    .word 0
    .word 0x40004000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x80000000, 0x80000000
    .word 0x00000000, 0x00000000
    .word 0x00800000, 0x00800000
    .word 0x7F000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x007F0000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0xE0011FFF, 0x00040000
    .word 0xFF000000, 0xFF000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x52535020, 0x53572056
    .word 0x65727369, 0x6F6E3A20
    .word 0x322E3044, 0x2C203034
    .word 0x2D30312D, 0x39360053
    .word 0x47492055, 0x36342047
    .word 0x46582053, 0x57205445
    .word 0x414D3A20, 0x5320416E
    .word 0x64657273, 0x6F6E2C20
    .word 0x53204361, 0x72722C20
    .word 0x48204368, 0x656E672C
    .word 0x204B204C, 0x75737465
    .word 0x722C2052, 0x204D6F6F
    .word 0x72652C20, 0x4E20506F
    .word 0x6F6C6579, 0x2C204120
    .word 0x5372696E, 0x69766173
    .word 0x616E0A00, 0x00000000
    .word 0x032001B0, 0x01D001F0
    .word 0x02100230, 0x02500270
    .word 0x029002B0, 0x02D00138
    .word 0x03F00400, 0x041003E0
    .word 0x012C0070, 0x01600330
    .word 0x01F00420, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x01000000, 0x00FF0000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000
    .word 0x00000000, 0x00000000

.align 8
data_end:

.org data_end
.if orga() < 0x800
    .fill 0x800-orga()
.endif

.close
