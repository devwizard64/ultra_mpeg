.create "build/src/PR/gspFast3D.fifo.main.bin", 0x04001000

prg_main_start:

_04001000:
    vrcph   $v27[3], $v29[3]
    vrcpl   $v26[3], $v28[3]
    vrcph   $v27[3], $v29[7]
    vrcpl   $v26[7], $v28[7]
    vrcph   $v27[7], $v31[0]
    vmudn   $v26, $v26, $v31[2]
    vmadh   $v27, $v27, $v31[2]
    vmadn   $v26, $v31, $v31[0]
    lqv     $v23[0], 0x0060($0)
    vxor    $v22, $v31, $v31
    vmudl   $v24, $v26, $v28
    vmadm   $v24, $v27, $v28
    vmadn   $v24, $v26, $v29
    vmadh   $v25, $v27, $v29
    vsubc   $v24, $v22, $v24
    vsub    $v25, $v23, $v25
    vmudl   $v22, $v26, $v24
    vmadm   $v23, $v27, $v24
    vmadn   $v26, $v26, $v25
    vmadh   $v27, $v27, $v25
    jr      $ra
    nop

cmd_next_sync:
    jal     dma_sync
    addi    $27, $0, 0x06A0
.cmd_proc:
    lw      $25, 0x0000($27)
    lw      $24, 0x0004($27)
    srl     $1, $25, 29
    andi    $1, $1, 0x0006
    addi    $26, $26, 0x0008
    addi    $27, $27, 0x0008
    addi    $28, $28, -0x0008
    bgtz    $1, .cmd_nodma
    andi    $18, $25, 0x01FF
    addi    $22, $0, 0x07E0
    jal     segment_to_physical
    add     $19, $24, $0
    add     $20, $0, $22
    jal     dma_start
    addi    $17, $0, 0x0000
.cmd_nodma:
    lh      $2, 0x00BC($1)
    jr      $2
    srl     $2, $25, 23

cmd_next:
    mfc0    $2, SP_STATUS
    andi    $2, $2, 0x0080
    bnez    $2, .task_yield
    lh      $21, 0x0026($0)

cmd_cont:
    bgtz    $28, .cmd_proc
    nop
    j       cmd_load
    lh      $ra, 0x0104($0)

task_exit:
    lh      $21, 0x00B6($0)
.task_yield:
    j       prg_jump
    ori     $30, $0, 0x0020

cmd_load:
    addi    $28, $0, 0x0140
    add     $21, $0, $ra
    addi    $20, $0, 0x06A0
    add     $19, $0, $26
    addi    $18, $0, 0x013F
    jal     dma_start
    addi    $17, $0, 0x0000
    jr      $21
    addi    $27, $0, 0x06A0

prg_load:
    add     $21, $0, $ra

prg_jump:
    lw      $19, 0x0000($30)
    lh      $18, 0x0004($30)
    lh      $20, 0x0006($30)
    jal     dma_start
    addi    $17, $0, 0x0000
    jal     dma_sync
    nop
    jr      $21

segment_to_physical:
    lw      $11, 0x00B8($0)
    srl     $12, $19, 22
    andi    $12, $12, 0x003C
    and     $19, $19, $11
    add     $13, $0, $12
    lw      $12, 0x0160($13)
    jr      $ra
    add     $19, $19, $12

dma_start:
    mfc0    $11, SP_DMA_FULL
    bnez    $11, dma_start
    nop
    mtc0    $20, SP_MEM_ADDR
    bgtz    $17, @@write
    mtc0    $19, SP_DRAM_ADDR
    jr      $ra
    mtc0    $18, SP_RD_LEN
@@write:
    jr      $ra
    mtc0    $18, SP_WR_LEN

dma_sync:
    mfc0    $11, SP_DMA_BUSY
    bnez    $11, dma_sync
    nop
    jr      $ra
    nop

rdp_write:
    add     $21, $0, $ra
    lw      $19, 0x0018($29)
    addi    $18, $23, -0x09E0
    lw      $23, 0x0044($29)
    blez    $18, @@end
    add     $20, $19, $18
    sub     $20, $23, $20
    bgez    $20, @@syncfit
@@syncready:
    mfc0    $20, DPC_STATUS
    andi    $20, $20, 0x0400
    bnez    $20, @@syncready
@@syncwrap:
    mfc0    $23, DPC_CURRENT
    lw      $19, 0x0040($29)
    beq     $23, $19, @@syncwrap
    nop
    mtc0    $19, DPC_START
@@syncfit:
    mfc0    $23, DPC_CURRENT
    sub     $20, $19, $23
    bgez    $20, @@write
    add     $20, $19, $18
    sub     $20, $20, $23
    bgez    $20, @@syncfit
    nop
@@write:
    add     $23, $19, $18
    addi    $18, $18, -0x0001
    addi    $20, $0, 0x09E0
    jal     dma_start
    addi    $17, $0, 0x0001
    jal     dma_sync
    sw      $23, 0x0018($29)
    mtc0    $23, DPC_END
@@end:
    jr      $21
    addi    $23, $0, 0x09E0

case_IMM:
    andi    $2, $2, 0x00FE
    lh      $2, 0x0076($2)
    jr      $2
    lbu     $1, -0x0001($27)

case_G_TRI1:
    lbu     $5, -0x0004($27)
    lbu     $1, -0x0003($27)
    lbu     $2, -0x0002($27)
    lbu     $3, -0x0001($27)
    sll     $5, $5, 2
    sll     $1, $1, 2
    sll     $2, $2, 2
    sll     $3, $3, 2
    addi    $1, $1, 0x0420
    addi    $2, $2, 0x0420
    addi    $3, $3, 0x0420
    sw      $1, 0x0DE0($0)
    sw      $2, 0x0DE4($0)
    sw      $3, 0x0DE8($0)
    lw      $4, 0x0DE0($5)
    j       rdp_tri
    lh      $30, 0x00BE($0)

case_G_POPMTX:
    lw      $19, 0x0024($29)
    lw      $3, 0x004C($29)
    addi    $20, $0, 0x0360
    addi    $18, $0, 0x003F
    sub     $3, $3, $19
    addi    $3, $3, -0x0280
    bgez    $3, cmd_next
    addi    $19, $19, -0x0040
    jal     dma_start
    addi    $17, $0, 0x0000
    jal     dma_sync
    addi    $3, $0, 0x03E0
    j       _04001444
    sw      $19, 0x0024($29)

case_G_MOVEWORD:
    lbu     $1, -0x0005($27)
    lhu     $2, -0x0007($27)
    lh      $5, 0x030E($1)
    add     $5, $5, $2
    j       cmd_next
    sw      $24, 0x0000($5)

case_G_TEXTURE:
    sw      $25, 0x0010($29)
    sw      $24, 0x0014($29)
    lh      $2, 0x0006($29)
    andi    $2, $2, 0xFFFD
    andi    $3, $25, 0x0001
    sll     $3, $3, 1
    or      $2, $2, $3
    j       cmd_next
    sh      $2, 0x0006($29)

case_G_SETOTHERMODE_H:
    j       .setothermode
    addi    $7, $29, 0x0008

case_G_SETOTHERMODE_L:
    addi    $7, $29, 0x000C
.setothermode:
    lw      $3, 0x0000($7)
    addi    $8, $0, -0x0001
    lbu     $5, -0x0005($27)
    lbu     $6, -0x0006($27)
    addi    $2, $0, 0x0001
    sllv    $2, $2, $5
    addi    $2, $2, -0x0001
    sllv    $2, $2, $6
    xor     $2, $2, $8
    and     $2, $2, $3
    or      $3, $2, $24
    sw      $3, 0x0000($7)
    lw      $25, 0x0008($29)
    j       rdp_cmd
    lw      $24, 0x000C($29)

case_G_CULLDL:
    andi    $25, $25, 0x03FF
    ori     $2, $0, 0xFFFF
@@loop:
    lh      $3, 0x0444($25)
    addi    $25, $25, 0x0028
    bne     $25, $24, @@loop
    and     $2, $2, $3
    beqz    $2, cmd_next

case_G_ENDDL:
    lb      $2, 0x0000($29)
    addi    $2, $2, -0x0004
    bltz    $2, task_exit
    addi    $3, $2, 0x0336
    lw      $26, 0x0000($3)
    sb      $2, 0x0000($29)
    j       cmd_next
    addi    $28, $0, 0x0000

case_G_SETGEOMETRYMODE:
    lw      $2, 0x0004($29)
    or      $2, $2, $24
    j       cmd_next
    sw      $2, 0x0004($29)

case_G_CLEARGEOMETRYMODE:
    lw      $2, 0x0004($29)
    addi    $3, $0, -0x0001
    xor     $3, $3, $24
    and     $2, $2, $3
    j       cmd_next
    sw      $2, 0x0004($29)

case_G_PERSPNORM:
    j       cmd_next
    sh      $24, 0x0002($29)

case_G_RDPHALF_1:
    j       cmd_cont
    sw      $24, -0x0004($29)

case_G_RDPHALF_CONT:
    ori     $2, $0, 0x0000

case_G_RDPHALF_2:
    j       rdp_cmd
    lw      $25, -0x0004($29)

case_RDP:
    sra     $2, $25, 24
    addi    $2, $2, 0x0003
    bltz    $2, rdp_cmd
    addi    $2, $2, 0x0018
    jal     segment_to_physical
    add     $19, $24, $0
    add     $24, $19, $0

rdp_cmd:
    sw      $25, 0x0000($23)
    sw      $24, 0x0004($23)
    jal     rdp_write
    addi    $23, $23, 0x0008
    bgtz    $2, cmd_next
    nop
    j       cmd_cont

case_DMA:
    andi    $2, $2, 0x01FE
    lh      $2, 0x00C4($2)
    jal     dma_sync
    lbu     $1, -0x0007($27)
    jr      $2
    andi    $6, $1, 0x000F

case_G_MTX:
    sbv     $v31[6], 0x001C($29)
    andi    $8, $1, 0x0001
    bnez    $8, .L04001454
    andi    $7, $1, 0x0002
    addi    $20, $0, 0x0360
    andi    $8, $1, 0x0004
    beqz    $8, .L04001420
    lqv     $v26[0], 0x0030($22)
    lw      $19, 0x0024($29)
    lw      $8, 0x004C($29)
    addi    $17, $0, 0x0001
    addi    $1, $19, 0x0040
    beq     $19, $8, .L04001420
    addi    $12, $0, 0x003F
    jal     dma_start
    sw      $1, 0x0024($29)
    jal     dma_sync
.L04001420:
    lqv     $v28[0], 0x0010($22)
    beqz    $7, .L04001460
    lqv     $v27[0], 0x0020($22)
    sqv     $v26[0], 0x0030($20)
    lqv     $v29[0], 0x0000($22)
    sqv     $v28[0], 0x0010($20)
.L04001438:
    addi    $3, $0, 0x03E0
    sqv     $v27[0], 0x0020($20)
    sqv     $v29[0], 0x0000($20)

_04001444:
    addi    $1, $0, 0x0360
    addi    $2, $0, 0x03A0
    j       _04001484
    lh      $ra, 0x00BE($0)
.L04001454:
    lqv     $v26[0], 0x0030($22)
    j       .L04001420
    addi    $20, $0, 0x03A0
.L04001460:
    addiu   $3, $0, 0x0DE0
    addu    $1, $0, $22
    jal     _04001484
    addu    $2, $0, $20
    sqv     $v6[0], 0x0030($20)
    sqv     $v5[0], 0x0010($20)
    lqv     $v27[0], 0x0000($3)
    j       .L04001438
    lqv     $v29[0], -0x0020($3)

_04001484:
    addi    $19, $3, 0x0010
.L04001488:
    vmudh   $v5, $v31, $v31[0]
    addi    $18, $1, 0x0008
.L04001490:
    ldv     $v3[0], 0x0000($2)
    ldv     $v4[0], 0x0020($2)
    lqv     $v1[0], 0x0000($1)
    lqv     $v2[0], 0x0020($1)
    ldv     $v3[8], 0x0000($2)
    ldv     $v4[8], 0x0020($2)
    vmadl   $v6, $v4, $v2[0h]
    addi    $1, $1, 0x0002
    vmadm   $v6, $v3, $v2[0h]
    addi    $2, $2, 0x0008
    vmadn   $v6, $v4, $v1[0h]
    vmadh   $v5, $v3, $v1[0h]
    bne     $1, $18, .L04001490
    vmadn   $v6, $v31, $v31[0]
    addi    $2, $2, -0x0020
    addi    $1, $1, 0x0008
    sqv     $v5[0], 0x0000($3)
    sqv     $v6[0], 0x0020($3)
    bne     $3, $19, .L04001488
    addi    $3, $3, 0x0010
    jr      $ra
    nop

_040014E8:
    addi    $8, $0, 0x0320
    lqv     $v3[0], 0x0050($0)
    lsv     $v19[0], 0x0002($29)
    lh      $3, 0x0004($29)
    ldv     $v0[0], 0x0000($8)
    ldv     $v1[0], 0x0008($8)
    ldv     $v0[8], 0x0000($8)
    ldv     $v1[8], 0x0008($8)
    jr      $ra
    vmudh   $v0, $v0, $v3

_04001510:
    addi    $8, $0, 0x03E0
    ldv     $v11[0], 0x0018($8)
    ldv     $v11[8], 0x0018($8)
    ldv     $v15[0], 0x0038($8)
    ldv     $v15[8], 0x0038($8)

_04001524:
    ldv     $v8[0], 0x0000($8)
    ldv     $v9[0], 0x0008($8)
    ldv     $v10[0], 0x0010($8)
    ldv     $v12[0], 0x0020($8)
    ldv     $v13[0], 0x0028($8)
    ldv     $v14[0], 0x0030($8)
    ldv     $v8[8], 0x0000($8)
    ldv     $v9[8], 0x0008($8)
    ldv     $v10[8], 0x0010($8)
    ldv     $v12[8], 0x0020($8)
    ldv     $v13[8], 0x0028($8)
    jr      $ra
    ldv     $v14[8], 0x0030($8)

case_G_MOVEMEM:
    lqv     $v0[0], 0x0000($22)
    lh      $5, 0x0270($1)
    j       cmd_next
    sqv     $v0[0], 0x0000($5)

case_G_VTX:
    lh      $8, 0x00BE($0)
    sh      $8, 0x0106($0)
    srl     $1, $1, 4
    addi    $5, $1, 0x0001
    addi    $9, $5, 0x0000
    ldv     $v2[0], 0x0000($22)
    ldv     $v2[8], 0x0010($22)
    addi    $7, $0, 0x0420
    sll     $8, $6, 5
    sll     $6, $6, 3
    add     $8, $6, $8
    jal     _040014E8
    add     $7, $7, $8
    llv     $v17[0], 0x0014($29)
    jal     _04001510
    llv     $v17[8], 0x0014($29)
.L040015A8:
    vmudn   $v28, $v12, $v2[0h]
    llv     $v18[0], 0x0008($22)
    vmadh   $v28, $v8, $v2[0h]
    lw      $15, 0x000C($22)
    vmadn   $v28, $v13, $v2[1h]
    lw      $16, 0x001C($22)
    vmadh   $v28, $v9, $v2[1h]
    andi    $1, $3, 0x0002
    vmadn   $v28, $v14, $v2[2h]
    vmadh   $v28, $v10, $v2[2h]
    vmadn   $v28, $v15, $v31[1]
    llv     $v18[8], 0x0018($22)
    vmadh   $v29, $v11, $v31[1]
    bnez    $1, @light
    addi    $22, $22, 0x0020
.light_return:
    vmudm   $v18, $v18, $v17
.vtx_clip_return:
    lsv     $v21[0], 0x0076($0)
    vmudn   $v20, $v28, $v21[0]
    vmadh   $v21, $v29, $v21[0]
    vch     $v3, $v29, $v29[3h]
    vcl     $v3, $v28, $v28[3h]
    cfc2    $13, $1
    vch     $v3, $v29, $v21[3h]
    vcl     $v3, $v28, $v20[3h]
    andi    $8, $13, 0x0707
    andi    $13, $13, 0x7070
    sll     $8, $8, 4
    sll     $13, $13, 16
    or      $13, $13, $8
    cfc2    $14, $1
    andi    $8, $14, 0x0707
    vadd    $v21, $v29, $v31[0]
    andi    $14, $14, 0x7070
    vadd    $v20, $v28, $v31[0]
    sll     $14, $14, 12
    vmudl   $v28, $v28, $v19[0]
    or      $8, $8, $14
    vmadm   $v29, $v29, $v19[0]
    or      $8, $8, $13
    vmadn   $v28, $v31, $v31[0]
    sh      $8, 0x0024($7)
    jal     _04001000
    lh      $13, -0x001A($22)
    vge     $v6, $v27, $v31[0]
    sdv     $v21[0], 0x0000($7)
    vmrg    $v6, $v27, $v30[0]
    sdv     $v20[0], 0x0008($7)
    vmudl   $v5, $v20, $v26[3h]
    vmadm   $v5, $v21, $v26[3h]
    vmadn   $v5, $v20, $v6[3h]
    vmadh   $v4, $v21, $v6[3h]
    addi    $9, $9, -0x0001
    vmudl   $v5, $v5, $v19[0]
    vmadm   $v4, $v4, $v19[0]
    vmadn   $v5, $v31, $v31[0]
    andi    $12, $3, 0x0001
    ldv     $v2[0], 0x0000($22)
    vmudh   $v7, $v1, $v31[1]
    ldv     $v2[8], 0x0010($22)
    vmadn   $v7, $v5, $v0
    ldv     $v29[0], 0x0028($0)
    vmadh   $v6, $v4, $v0
    ldv     $v29[8], 0x0028($0)
    vmadn   $v7, $v31, $v31[0]
    vge     $v6, $v6, $v29[1q]
    sw      $15, 0x0010($7)
    beqz    $12, .L040016E0
    vlt     $v6, $v6, $v29[0q]
    lqv     $v3[0], 0x0330($0)
    vmudn   $v5, $v5, $v3[0]
    vmadh   $v4, $v4, $v3[0]
    vadd    $v4, $v4, $v3[1]
    vge     $v4, $v4, $v31[0]
    vlt     $v4, $v4, $v3[2]
    sbv     $v4[5], 0x0013($7)
    sw      $16, 0x0018($7)
    sbv     $v4[13], 0x001B($7)
    lw      $16, 0x0018($7)
.L040016E0:
    slv     $v18[0], 0x0014($7)
    sdv     $v6[0], 0x0018($7)
    ssv     $v7[4], 0x001E($7)
    ssv     $v27[6], 0x0020($7)
    ssv     $v26[6], 0x0022($7)
    blez    $9, .L04001728
    addi    $9, $9, -0x0001
    sdv     $v21[8], 0x0028($7)
    sdv     $v20[8], 0x0030($7)
    slv     $v18[8], 0x003C($7)
    sw      $16, 0x0038($7)
    sdv     $v6[8], 0x0040($7)
    ssv     $v7[12], 0x0046($7)
    ssv     $v27[14], 0x0048($7)
    ssv     $v26[14], 0x004A($7)
    sw      $8, 0x004C($7)
    addi    $7, $7, 0x0050
    bgtz    $9, .L040015A8
.L04001728:
    lh      $8, 0x0106($0)
    jr      $8
    nop

case_G_DL:
    bgtz    $1, @@nopush
    lb      $2, 0x0000($29)
    addi    $4, $2, -0x0024
    bgtz    $4, cmd_next
    addi    $3, $2, 0x0336
    addi    $2, $2, 0x0004
    sw      $26, 0x0000($3)
    sb      $2, 0x0000($29)
@@nopush:
    jal     segment_to_physical
    add     $19, $24, $0
    add     $26, $19, $0
    j       cmd_next
    addi    $28, $0, 0x0000

.align 8
prg_ext_start:

@clip:
    ori     $30, $0, 0x0010
    b       prg_jump
    lh      $21, 0x0100($0)

@light:
    ori     $30, $0, 0x0018
    b       prg_jump
    lh      $21, 0x00A0($0)

init:
    ori     $2, $0, 0x2800
    mtc0    $2, SP_STATUS
    lqv     $v31[0], 0x0030($0)
    lqv     $v30[0], 0x0040($0)
    lw      $4, 0x0FC4($0)
    andi    $4, $4, 0x0001
    bnez    $4, @@fromyield
    nop
    lw      $23, 0x0028($1)
    lw      $3, 0x002C($1)
    sw      $23, 0x0040($29)
    sw      $3, 0x0044($29)
    mfc0    $4, DPC_STATUS
    andi    $4, $4, 0x0001
    bnez    $4, @@initfifo
    mfc0    $4, DPC_END
    sub     $23, $23, $4
    bgtz    $23, @@initfifo
    mfc0    $5, DPC_CURRENT
    beqz    $5, @@initfifo
    nop
    beq     $5, $4, @@initfifo
    nop
    j       @@noinitfifo
    ori     $3, $4, 0x0000
@@initfifo:
    mfc0    $4, DPC_STATUS
    andi    $4, $4, 0x0400
    bnez    $4, @@initfifo
    addi    $4, $0, 0x0001
    mtc0    $4, DPC_STATUS
    mtc0    $3, DPC_START
    mtc0    $3, DPC_END
@@noinitfifo:
    sw      $3, 0x0018($29)
    addi    $23, $0, 0x09E0
    lw      $5, 0x0010($1)
    lw      $2, 0x0008($0)
    lw      $3, 0x0010($0)
    lw      $4, 0x0018($0)
    lw      $6, 0x0020($0)
    add     $2, $2, $5
    add     $3, $3, $5
    add     $4, $4, $5
    add     $6, $6, $5
    sw      $2, 0x0008($0)
    sw      $3, 0x0010($0)
    sw      $4, 0x0018($0)
    sw      $6, 0x0020($0)
    jal     prg_load
    addi    $30, $0, 0x0008
    jal     cmd_load
    lw      $26, 0x0030($1)
    lw      $2, 0x0020($1)
    sw      $2, 0x0020($29)
    sw      $2, 0x0024($29)
    addi    $2, $2, 0x0280
    sw      $2, 0x004C($29)
    lw      $2, -0x0008($0)
    sw      $2, 0x0108($0)
    j       cmd_next_sync
    nop
@@fromyield:
    jal     prg_load
    addi    $30, $0, 0x0008
    lw      $23, 0x08F0($0)
    lw      $28, 0x08E4($0)
    lw      $27, 0x08E8($0)
    j       cmd_next
    lw      $26, 0x08EC($0)

.fill max(prg_clip_end, prg_light_end, prg_exit_end)-. + 0x10

rdp_tri:
    lh      $11, 0x0024($3)
    lh      $8, 0x0024($2)
    lh      $9, 0x0024($1)
    and     $12, $11, $8
    or      $11, $11, $8
    and     $12, $12, $9
    andi    $12, $12, 0x7070
    bnez    $12, cmd_next
    or      $11, $11, $9
    andi    $11, $11, 0x4343
    bnez    $11, @clip
.clip_return:
    llv     $v13[0], 0x0018($1)
    llv     $v14[0], 0x0018($2)
    llv     $v15[0], 0x0018($3)
    lw      $13, 0x0004($29)
    addi    $8, $0, 0x08E0
    lsv     $v21[0], 0x0002($29)
    lsv     $v5[0], 0x0006($1)
    vsub    $v10, $v14, $v13
    lsv     $v6[0], 0x000E($1)
    vsub    $v9, $v15, $v13
    lsv     $v5[2], 0x0006($2)
    vsub    $v12, $v13, $v14
    lsv     $v6[2], 0x000E($2)
    lsv     $v5[4], 0x0006($3)
    lsv     $v6[4], 0x000E($3)
    vmudh   $v16, $v9, $v10[1]
    lh      $9, 0x001A($1)
    vsar    $v18, $v18, $v18[1]
    lh      $10, 0x001A($2)
    vsar    $v17, $v17, $v17[0]
    lh      $11, 0x001A($3)
    vmudh   $v16, $v12, $v9[1]
    andi    $14, $13, 0x1000
    vsar    $v20, $v20, $v20[1]
    andi    $15, $13, 0x2000
    vsar    $v19, $v19, $v19[0]
    addi    $12, $0, 0x0000
.L04001A30:
    slt     $7, $10, $9
    blez    $7, .L04001A58
    add     $7, $10, $0
    add     $10, $9, $0
    add     $9, $7, $0
    addu    $7, $2, $0
    addu    $2, $1, $0
    addu    $1, $7, $0
    xori    $12, $12, 0x0001
    nop
.L04001A58:
    vaddc   $v28, $v18, $v20
    slt     $7, $11, $10
    vadd    $v29, $v17, $v19
    blez    $7, .L04001A88
    add     $7, $11, $0
    add     $11, $10, $0
    add     $10, $7, $0
    addu    $7, $3, $0
    addu    $3, $2, $0
    addu    $2, $7, $0
    j       .L04001A30
    xori    $12, $12, 0x0001
.L04001A88:
    vlt     $v27, $v29, $v31[0]
    llv     $v15[0], 0x0018($3)
    vor     $v26, $v29, $v28
    llv     $v14[0], 0x0018($2)
    llv     $v13[0], 0x0018($1)
    blez    $12, .L04001AB0
    vsub    $v4, $v15, $v14
    vmudn   $v28, $v28, $v31[3]
    vmadh   $v29, $v29, $v31[3]
    vmadn   $v28, $v31, $v31[0]
.L04001AB0:
    vsub    $v10, $v14, $v13
    mfc2    $17, $v27[0]
    vsub    $v9, $v15, $v13
    mfc2    $16, $v26[0]
    sra     $17, $17, 31
    vmov    $v29[3], $v29[0]
    and     $15, $15, $17
    vmov    $v28[3], $v28[0]
    vmov    $v4[2], $v10[0]
    beqz    $16, .L04001FD0
    xori    $17, $17, 0xFFFF
    vlt     $v27, $v29, $v31[0]
    and     $14, $14, $17
    vmov    $v4[3], $v10[1]
    or      $16, $15, $14
    vmov    $v4[4], $v9[0]
    bgtz    $16, .L04001FD0
    vmov    $v4[5], $v9[1]
    mfc2    $7, $v27[0]
    jal     _04001000
    addi    $6, $0, 0x0080
    bltz    $7, .L04001B10
    lb      $5, 0x0007($29)
    addi    $6, $0, 0x0000
.L04001B10:
    vmudm   $v9, $v4, $v31[4]
    vmadn   $v10, $v31, $v31[0]
    vrcp    $v8[1], $v4[1]
    vrcph   $v7[1], $v31[0]
    ori     $5, $5, 0x00C8
    lb      $7, 0x0012($29)
    vrcp    $v8[3], $v4[3]
    vrcph   $v7[3], $v31[0]
    vrcp    $v8[5], $v4[5]
    vrcph   $v7[5], $v31[0]
    or      $6, $6, $7
    vmudl   $v8, $v8, $v30[4]
    sb      $5, 0x0000($23)
    vmadm   $v7, $v7, $v30[4]
    sb      $6, 0x0001($23)
    vmadn   $v8, $v31, $v31[0]
    vmudh   $v4, $v4, $v31[5]
    lsv     $v12[0], 0x0018($2)
    vmudl   $v6, $v6, $v21[0]
    lsv     $v12[4], 0x0018($1)
    vmadm   $v5, $v5, $v21[0]
    lsv     $v12[8], 0x0018($1)
    vmadn   $v6, $v31, $v31[0]
    sll     $7, $9, 14
    vmudl   $v1, $v8, $v10[0q]
    vmadm   $v1, $v7, $v10[0q]
    vmadn   $v1, $v8, $v9[0q]
    vmadh   $v0, $v7, $v9[0q]
    mtc2    $7, $v2[0]
    vmadn   $v1, $v31, $v31[0]
    sw      $3, 0x0000($8)
    vmudl   $v8, $v8, $v31[4]
    vmadm   $v7, $v7, $v31[4]
    vmadn   $v8, $v31, $v31[0]
    vmudl   $v1, $v1, $v31[4]
    vmadm   $v0, $v0, $v31[4]
    vmadn   $v1, $v31, $v31[0]
    sh      $11, 0x0002($23)
    vand    $v16, $v1, $v30[1]
    sh      $9, 0x0006($23)
    vmudm   $v12, $v12, $v31[4]
    sw      $2, 0x0004($8)
    vmadn   $v13, $v31, $v31[0]
    sw      $1, 0x0008($8)
    sh      $10, 0x0004($23)
    vcr     $v0, $v0, $v30[6]
    ssv     $v12[0], 0x0008($23)
    vmudl   $v11, $v16, $v2[0]
    ssv     $v13[0], 0x000A($23)
    vmadm   $v10, $v0, $v2[0]
    ssv     $v0[2], 0x000C($23)
    vmadn   $v11, $v31, $v31[0]
    ssv     $v1[2], 0x000E($23)
    andi    $7, $5, 0x0002
    addi    $15, $8, 0x0008
    addi    $16, $8, 0x0010
    vsubc   $v3, $v13, $v11[1q]
    ssv     $v0[10], 0x0014($23)
    vsub    $v9, $v12, $v10[1q]
    ssv     $v1[10], 0x0016($23)
    vsubc   $v21, $v6, $v6[1]
    ssv     $v0[6], 0x001C($23)
    vlt     $v19, $v5, $v5[1]
    ssv     $v1[6], 0x001E($23)
    vmrg    $v20, $v6, $v6[1]
    ssv     $v9[8], 0x0010($23)
    vsubc   $v21, $v20, $v6[2]
    ssv     $v3[8], 0x0012($23)
    vlt     $v19, $v19, $v5[2]
    ssv     $v9[4], 0x0018($23)
    vmrg    $v20, $v20, $v6[2]
    ssv     $v3[4], 0x001A($23)
    addi    $23, $23, 0x0020
    blez    $7, .L04001CFC
    vmudl   $v20, $v20, $v30[5]
    lw      $14, 0x0000($15)
    vmadm   $v19, $v19, $v30[5]
    lw      $17, -0x0004($15)
    vmadn   $v20, $v31, $v31[0]
    lw      $18, -0x0008($15)
    llv     $v9[0], 0x0014($14)
    llv     $v9[8], 0x0014($17)
    llv     $v22[0], 0x0014($18)
    lsv     $v11[0], 0x0022($14)
    lsv     $v12[0], 0x0020($14)
    lsv     $v11[8], 0x0022($17)
    vmov    $v9[2], $v30[0]
    lsv     $v12[8], 0x0020($17)
    vmov    $v9[6], $v30[0]
    lsv     $v24[0], 0x0022($18)
    vmov    $v22[2], $v30[0]
    lsv     $v25[0], 0x0020($18)
    vmudl   $v6, $v11, $v20[0]
    vmadm   $v6, $v12, $v20[0]
    ssv     $v19[0], 0x0044($8)
    vmadn   $v6, $v11, $v19[0]
    ssv     $v20[0], 0x004C($8)
    vmadh   $v5, $v12, $v19[0]
    vmudl   $v16, $v24, $v20[0]
    vmadm   $v16, $v25, $v20[0]
    vmadn   $v20, $v24, $v19[0]
    vmadh   $v19, $v25, $v19[0]
    vmudm   $v16, $v9, $v6[0h]
    vmadh   $v9, $v9, $v5[0h]
    vmadn   $v10, $v31, $v31[0]
    vmudm   $v16, $v22, $v20[0]
    vmadh   $v22, $v22, $v19[0]
    vmadn   $v23, $v31, $v31[0]
    sdv     $v9[8], 0x0010($16)
    sdv     $v10[8], 0x0018($16)
    sdv     $v9[0], 0x0000($16)
    sdv     $v10[0], 0x0008($16)
    sdv     $v22[0], 0x0020($16)
    sdv     $v23[0], 0x0028($16)
    vabs    $v9, $v9, $v9
    llv     $v19[0], 0x0010($16)
    vabs    $v22, $v22, $v22
    llv     $v20[0], 0x0018($16)
    vabs    $v19, $v19, $v19
    vge     $v17, $v9, $v22
    vmrg    $v18, $v10, $v23
    vge     $v17, $v17, $v19
    vmrg    $v18, $v18, $v20
.L04001CFC:
    slv     $v17[0], 0x0040($8)
    slv     $v18[0], 0x0048($8)
    andi    $7, $5, 0x0007
    blez    $7, .L04001FCC
    vxor    $v18, $v31, $v31
    luv     $v25[0], 0x0010($3)
    vadd    $v16, $v18, $v30[5]
    luv     $v15[0], 0x0010($1)
    vadd    $v24, $v18, $v30[5]
    andi    $7, $13, 0x0200
    vadd    $v5, $v18, $v30[5]
    bgtz    $7, .L04001D3C
    luv     $v23[0], 0x0010($2)
    luv     $v25[0], 0x0010($4)
    luv     $v15[0], 0x0010($4)
    luv     $v23[0], 0x0010($4)
.L04001D3C:
    vmudm   $v25, $v25, $v31[7]
    vmudm   $v15, $v15, $v31[7]
    vmudm   $v23, $v23, $v31[7]
    ldv     $v16[8], 0x0018($8)
    ldv     $v15[8], 0x0010($8)
    ldv     $v24[8], 0x0028($8)
    ldv     $v23[8], 0x0020($8)
    ldv     $v5[8], 0x0038($8)
    ldv     $v25[8], 0x0030($8)
    lsv     $v16[14], 0x001E($1)
    lsv     $v15[14], 0x001C($1)
    lsv     $v24[14], 0x001E($2)
    lsv     $v23[14], 0x001C($2)
    lsv     $v5[14], 0x001E($3)
    lsv     $v25[14], 0x001C($3)
    vsubc   $v12, $v24, $v16
    vsub    $v11, $v23, $v15
    vsubc   $v20, $v16, $v5
    vsub    $v19, $v15, $v25
    vsubc   $v10, $v5, $v16
    vsub    $v9, $v25, $v15
    vsubc   $v22, $v16, $v24
    vsub    $v21, $v15, $v23
    vmudn   $v6, $v10, $v4[3]
    vmadh   $v6, $v9, $v4[3]
    vmadn   $v6, $v22, $v4[5]
    vmadh   $v6, $v21, $v4[5]
    vsar    $v9, $v9, $v9[0]
    vsar    $v10, $v10, $v10[1]
    vmudn   $v6, $v12, $v4[4]
    vmadh   $v6, $v11, $v4[4]
    vmadn   $v6, $v20, $v4[2]
    vmadh   $v6, $v19, $v4[2]
    vsar    $v11, $v11, $v11[0]
    vsar    $v12, $v12, $v12[1]
    vmudl   $v6, $v10, $v26[3]
    vmadm   $v6, $v9, $v26[3]
    vmadn   $v10, $v10, $v27[3]
    vmadh   $v9, $v9, $v27[3]
    vmudl   $v6, $v12, $v26[3]
    vmadm   $v6, $v11, $v26[3]
    vmadn   $v12, $v12, $v27[3]
    sdv     $v9[0], 0x0008($23)
    vmadh   $v11, $v11, $v27[3]
    sdv     $v10[0], 0x0018($23)
    vmudn   $v6, $v12, $v31[1]
    vmadh   $v6, $v11, $v31[1]
    vmadl   $v6, $v10, $v1[5]
    vmadm   $v6, $v9, $v1[5]
    vmadn   $v14, $v10, $v0[5]
    sdv     $v11[0], 0x0028($23)
    vmadh   $v13, $v9, $v0[5]
    sdv     $v12[0], 0x0038($23)
    vmudl   $v28, $v14, $v2[0]
    sdv     $v13[0], 0x0020($23)
    vmadm   $v6, $v13, $v2[0]
    sdv     $v14[0], 0x0030($23)
    vmadn   $v28, $v31, $v31[0]
    vsubc   $v18, $v16, $v28
    vsub    $v17, $v15, $v6
    andi    $7, $5, 0x0004
    blez    $7, .L04001E44
    andi    $7, $5, 0x0002
    addi    $23, $23, 0x0040
    sdv     $v17[0], -0x0040($23)
    sdv     $v18[0], -0x0030($23)
.L04001E44:
    blez    $7, .L04001F48
    andi    $7, $5, 0x0001
    addi    $16, $0, 0x0800
    mtc2    $16, $v19[0]
    vabs    $v24, $v9, $v9
    ldv     $v20[8], 0x0040($8)
    vabs    $v25, $v11, $v11
    ldv     $v21[8], 0x0048($8)
    vmudm   $v24, $v24, $v19[0]
    vmadn   $v26, $v31, $v31[0]
    vmudm   $v25, $v25, $v19[0]
    vmadn   $v27, $v31, $v31[0]
    vmudl   $v21, $v21, $v19[0]
    vmadm   $v20, $v20, $v19[0]
    vmadn   $v21, $v31, $v31[0]
    vmudn   $v26, $v26, $v31[2]
    vmadh   $v24, $v24, $v31[2]
    vmadn   $v26, $v31, $v31[0]
    vmadn   $v23, $v27, $v31[1]
    vmadh   $v22, $v25, $v31[1]
    addi    $16, $0, 0x0040
    vmadn   $v6, $v21, $v31[1]
    mtc2    $16, $v19[0]
    vmadh   $v5, $v20, $v31[1]
    vsubc   $v23, $v6, $v6[5]
    vge     $v5, $v5, $v5[5]
    vmrg    $v6, $v6, $v6[5]
    vsubc   $v23, $v6, $v6[6]
    vge     $v5, $v5, $v5[6]
    vmrg    $v6, $v6, $v6[6]
    vmudl   $v6, $v6, $v19[0]
    vmadm   $v5, $v5, $v19[0]
    vmadn   $v6, $v31, $v31[0]
    vrcph   $v23[0], $v5[4]
    vrcpl   $v6[0], $v6[4]
    vrcph   $v5[0], $v31[0]
    vmudn   $v6, $v6, $v31[2]
    vmadh   $v5, $v5, $v31[2]
    vlt     $v5, $v5, $v31[1]
    vmrg    $v6, $v6, $v31[0]
    vmudl   $v20, $v18, $v6[0]
    vmadm   $v20, $v17, $v6[0]
    vmadn   $v20, $v18, $v5[0]
    vmadh   $v19, $v17, $v5[0]
    vmudl   $v22, $v10, $v6[0]
    vmadm   $v22, $v9, $v6[0]
    vmadn   $v22, $v10, $v5[0]
    sdv     $v19[8], 0x0000($23)
    vmadh   $v21, $v9, $v5[0]
    sdv     $v20[8], 0x0010($23)
    vmudl   $v24, $v12, $v6[0]
    vmadm   $v24, $v11, $v6[0]
    vmadn   $v24, $v12, $v5[0]
    sdv     $v21[8], 0x0008($23)
    vmadh   $v23, $v11, $v5[0]
    sdv     $v22[8], 0x0018($23)
    vmudl   $v26, $v14, $v6[0]
    vmadm   $v26, $v13, $v6[0]
    vmadn   $v26, $v14, $v5[0]
    sdv     $v23[8], 0x0028($23)
    vmadh   $v25, $v13, $v5[0]
    sdv     $v24[8], 0x0038($23)
    addi    $23, $23, 0x0040
    sdv     $v25[8], -0x0020($23)
    sdv     $v26[8], -0x0010($23)
.L04001F48:
    blez    $7, .L04001FCC
    vmudn   $v14, $v14, $v30[4]
    vmadh   $v13, $v13, $v30[4]
    vmadn   $v14, $v31, $v31[0]
    vmudn   $v16, $v16, $v30[4]
    vmadh   $v15, $v15, $v30[4]
    vmadn   $v16, $v31, $v31[0]
    ssv     $v13[14], 0x0008($23)
    vmudn   $v10, $v10, $v30[4]
    ssv     $v14[14], 0x000A($23)
    vmadh   $v9, $v9, $v30[4]
    vmadn   $v10, $v31, $v31[0]
    vmudn   $v12, $v12, $v30[4]
    vmadh   $v11, $v11, $v30[4]
    vmadn   $v12, $v31, $v31[0]
    lbu     $7, 0x0011($29)
    sub     $7, $0, $7
    beqz    $7, .L04001F9C
    mtc2    $7, $v6[0]
    vch     $v11, $v11, $v6[0]
    vcl     $v12, $v12, $v31[0]
.L04001F9C:
    ssv     $v9[14], 0x0004($23)
    vmudl   $v28, $v14, $v2[0]
    ssv     $v10[14], 0x0006($23)
    vmadm   $v6, $v13, $v2[0]
    ssv     $v11[14], 0x000C($23)
    vmadn   $v28, $v31, $v31[0]
    ssv     $v12[14], 0x000E($23)
    vsubc   $v18, $v16, $v28
    vsub    $v17, $v15, $v6
    addi    $23, $23, 0x0010
    ssv     $v17[14], -0x0010($23)
    ssv     $v18[14], -0x000E($23)
.L04001FCC:
    jal     rdp_write
.L04001FD0:
    nop
    jr      $30
    nop

.align 8

.close
