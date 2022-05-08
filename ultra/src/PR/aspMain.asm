.include "src/PR/rsp.inc"

.create "build/src/PR/aspMain.text.bin", 0x04001080

    addi    $24, $0, 0x0360
    addi    $23, $0, 0x0F90
    lw      $28, 0x0030($1)
    lw      $27, 0x0034($1)
    mfc0    $5, DPC_STATUS
    andi    $4, $5, 0x0001
    beqz    $4, .L040010B4
    andi    $4, $5, 0x0100
    beqz    $4, .L040010B4
    nop
.L040010A8:
    mfc0    $4, DPC_STATUS
    andi    $4, $4, 0x0100
    bgtz    $4, .L040010A8
.L040010B4:
    nop
    jal     cmd_load
    nop
    addi    $2, $0, 0x000F
    addi    $1, $0, 0x0320
.L040010C8:
    sw      $0, 0x0000($1)
    bgtz    $2, .L040010C8
    addi    $2, $2, -0x0001
.cmd_proc:
    mfc0    $2, SP_DMA_BUSY
    bnez    $2, .cmd_proc
    addi    $29, $0, 0x0380
    mtc0    $0, SP_SEMAPHORE
.L040010E4:
    lw      $26, 0x0000($29)
    lw      $25, 0x0004($29)
    srl     $1, $26, 23
    andi    $1, $1, 0x00FE
    addi    $28, $28, 0x0008
    addi    $27, $27, -0x0008
    addi    $29, $29, 0x0008
    addi    $30, $30, -0x0008
    add     $2, $0, $1
    lh      $2, 0x0010($2)
    jr      $2
    nop
    break   0

cmd_next:
    bgtz    $30, .L040010E4
    nop
    blez    $27, .L04001138
    nop
    jal     cmd_load
    nop
    j       .cmd_proc
    nop
.L04001138:
    ori     $1, $0, 0x4000
    mtc0    $1, SP_STATUS
    break   0
    nop
.L04001148:
    b       .L04001148
    nop

cmd_load:
    addi    $5, $ra, 0x0000
    add     $2, $0, $28
    addi    $3, $27, 0x0000
    addi    $4, $3, -0x0140
    blez    $4, .L0400116C
    addi    $1, $0, 0x0380
    addi    $3, $0, 0x0140
.L0400116C:
    addi    $30, $3, 0x0000
    jal     dma_read
    addi    $3, $3, -0x0001
    addi    $29, $0, 0x0380
    jr      $5
    nop

dma_read:
    mfc0    $4, SP_SEMAPHORE
    bnez    $4, dma_read
    nop
.L04001190:
    mfc0    $4, SP_DMA_FULL
    bnez    $4, .L04001190
    nop
    mtc0    $1, SP_MEM_ADDR
    mtc0    $2, SP_DRAM_ADDR
    mtc0    $3, SP_RD_LEN
    jr      $ra
    nop

dma_write:
    mfc0    $4, SP_SEMAPHORE
    bnez    $4, dma_write
    nop
.L040011BC:
    mfc0    $4, SP_DMA_FULL
    bnez    $4, .L040011BC
    nop
    mtc0    $1, SP_MEM_ADDR
    mtc0    $2, SP_DRAM_ADDR
    mtc0    $3, SP_WR_LEN
    jr      $ra
    nop

case_A_CLEARBUFF:
    andi    $3, $25, 0xFFFF
    beqz    $3, cmd_next
    addi    $4, $0, 0x05C0
    andi    $2, $26, 0xFFFF
    add     $2, $2, $4
    vxor    $v1, $v1, $v1
    addi    $3, $3, -0x0010
.L040011F8:
    sdv     $v1[0], 0x0000($2)
    sdv     $v1[0], 0x0008($2)
    addi    $2, $2, 0x0010
    bgtz    $3, .L040011F8
    addi    $3, $3, -0x0010
    j       cmd_next
    nop

case_A_LOADBUFF:
    lhu     $3, 0x0004($24)
    beqz    $3, cmd_next
    sll     $2, $25, 8
    srl     $2, $2, 8
    srl     $4, $25, 24
    sll     $4, $4, 2
    lw      $5, 0x0320($4)
    add     $2, $2, $5
    lhu     $1, 0x0000($24)
    jal     dma_read
    addi    $3, $3, -0x0001
.L04001240:
    mfc0    $1, SP_DMA_BUSY
    bnez    $1, .L04001240
    nop
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_SAVEBUFF:
    lhu     $3, 0x0004($24)
    beqz    $3, cmd_next
    sll     $2, $25, 8
    srl     $2, $2, 8
    srl     $4, $25, 24
    sll     $4, $4, 2
    lw      $5, 0x0320($4)
    add     $2, $2, $5
    lhu     $1, 0x0002($24)
    jal     dma_write
    addi    $3, $3, -0x0001
.L04001280:
    mfc0    $1, SP_DMA_BUSY
    bnez    $1, .L04001280
    nop
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_LOADADPCM:
    sll     $2, $25, 8
    srl     $2, $2, 8
    srl     $4, $25, 24
    sll     $4, $4, 2
    lw      $5, 0x0320($4)
    add     $2, $2, $5
    addi    $1, $0, 0x04C0
    andi    $3, $26, 0xFFFF
    jal     dma_read
    addi    $3, $3, -0x0001
.L040012BC:
    mfc0    $1, SP_DMA_BUSY
    bnez    $1, .L040012BC
    nop
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_SEGMENT:
    sll     $3, $25, 8
    srl     $3, $3, 8
    srl     $2, $25, 24
    sll     $2, $2, 2
    add     $4, $0, $2
    j       cmd_next
    sw      $3, 0x0320($4)

case_A_SETBUFF:
    addi    $1, $26, 0x05C0
    srl     $2, $25, 16
    addi    $2, $2, 0x05C0
    srl     $4, $26, 16
    andi    $4, $4, 0x0008
    bgtz    $4, .L04001318
    addi    $3, $25, 0x05C0
    sh      $1, 0x0000($24)
    sh      $2, 0x0002($24)
    j       cmd_next
    sh      $25, 0x0004($24)
.L04001318:
    sh      $3, 0x000E($24)
    sh      $1, 0x000A($24)
    j       cmd_next
    sh      $2, 0x000C($24)

case_A_SETVOL:
    srl     $2, $26, 16
    andi    $1, $2, 0x0008
    beqz    $1, .L04001344
    andi    $1, $2, 0x0004
    sh      $26, 0x001C($24)
    j       cmd_next
    sh      $25, 0x001E($24)
.L04001344:
    beqz    $1, .L04001364
    andi    $1, $2, 0x0002
    beqz    $1, .L0400135C
    nop
    j       cmd_next
    sh      $26, 0x0006($24)
.L0400135C:
    j       cmd_next
    sh      $26, 0x0008($24)
.L04001364:
    beqz    $1, .L0400137C
    srl     $1, $25, 16
    sh      $26, 0x0010($24)
    sh      $1, 0x0012($24)
    j       cmd_next
    sh      $25, 0x0014($24)
.L0400137C:
    sh      $26, 0x0016($24)
    sh      $1, 0x0018($24)
    j       cmd_next
    sh      $25, 0x001A($24)

case_A_INTERLEAVE:
    lhu     $1, 0x0004($24)
    lhu     $4, 0x0002($24)
    beqz    $1, cmd_next
    andi    $3, $25, 0xFFFF
    addi    $3, $3, 0x05C0
    srl     $2, $25, 16
    addi    $2, $2, 0x05C0
.L040013A8:
    lqv     $v1[0], 0x0000($2)
    lqv     $v2[0], 0x0000($3)
    ssv     $v1[0], 0x0000($4)
    ssv     $v2[0], 0x0002($4)
    ssv     $v1[2], 0x0004($4)
    ssv     $v2[2], 0x0006($4)
    ssv     $v1[4], 0x0008($4)
    ssv     $v2[4], 0x000A($4)
    ssv     $v1[6], 0x000C($4)
    ssv     $v2[6], 0x000E($4)
    ssv     $v1[8], 0x0010($4)
    ssv     $v2[8], 0x0012($4)
    ssv     $v1[10], 0x0014($4)
    ssv     $v2[10], 0x0016($4)
    ssv     $v1[12], 0x0018($4)
    ssv     $v2[12], 0x001A($4)
    ssv     $v1[14], 0x001C($4)
    ssv     $v2[14], 0x001E($4)
    addi    $1, $1, -0x0010
    addi    $2, $2, 0x0010
    addi    $3, $3, 0x0010
    bgtz    $1, .L040013A8
    addi    $4, $4, 0x0020
    j       cmd_next
    nop

case_A_DMEMMOVE:
    andi    $1, $25, 0xFFFF
    beqz    $1, cmd_next
    andi    $2, $26, 0xFFFF
    addi    $2, $2, 0x05C0
    srl     $3, $25, 16
    addi    $3, $3, 0x05C0
.L04001424:
    ldv     $v1[0], 0x0000($2)
    ldv     $v2[0], 0x0008($2)
    addi    $1, $1, -0x0010
    addi    $2, $2, 0x0010
    sdv     $v1[0], 0x0000($3)
    sdv     $v2[0], 0x0008($3)
    bgtz    $1, .L04001424
    addi    $3, $3, 0x0010
    j       cmd_next
    nop

case_A_SETLOOP:
    sll     $1, $25, 8
    srl     $1, $1, 8
    srl     $3, $25, 24
    sll     $3, $3, 2
    lw      $2, 0x0320($3)
    add     $1, $1, $2
    sw      $1, 0x0010($24)
    j       cmd_next
    nop

case_A_ADPCM:
    lqv     $v31[0], 0x0000($0)
    vxor    $v27, $v27, $v27
    lhu     $21, 0x0000($24)
    vxor    $v25, $v25, $v25
    vxor    $v24, $v24, $v24
    addi    $20, $21, 0x0001
    lhu     $19, 0x0002($24)
    vxor    $v13, $v13, $v13
    vxor    $v14, $v14, $v14
    lhu     $18, 0x0004($24)
    vxor    $v15, $v15, $v15
    lui     $1, 0x00FFFFFF >> 16
    vxor    $v16, $v16, $v16
    ori     $1, 0x00FFFFFF & 0xFFFF
    vxor    $v17, $v17, $v17
    and     $17, $25, $1
    vxor    $v18, $v18, $v18
    srl     $2, $25, 24
    vxor    $v19, $v19, $v19
    sll     $2, $2, 2
    lw      $3, 0x0320($2)
    add     $17, $17, $3
    sqv     $v27[0], 0x0000($19)
    sqv     $v27[0], 0x0010($19)
    srl     $1, $26, 16
    andi    $1, $1, 0x0001
    bgtz    $1, .L0400150C
    srl     $1, $26, 16
    andi    $1, $1, 0x0002
    beq     $0, $1, .L040014F0
    addi    $2, $17, 0x0000
    lw      $2, 0x0010($24)
.L040014F0:
    addi    $1, $19, 0x0000
    jal     dma_read
    addi    $3, $0, 0x001F
.L040014FC:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L040014FC
    nop
    mtc0    $0, SP_SEMAPHORE
.L0400150C:
    addi    $16, $0, 0x0030
    addi    $15, $0, 0x04C0
    ldv     $v25[0], 0x0000($16)
    ldv     $v24[8], 0x0000($16)
    ldv     $v23[0], 0x0008($16)
    ldv     $v23[8], 0x0008($16)
    lqv     $v27[0], 0x0010($19)
    addi    $19, $19, 0x0020
    beqz    $18, .L040016E8
    ldv     $v1[0], 0x0000($20)
    lbu     $1, 0x0000($21)
    andi    $11, $1, 0x000F
    sll     $11, $11, 5
    vand    $v3, $v25, $v1[0]
    add     $13, $11, $15
    vand    $v4, $v24, $v1[1]
    srl     $14, $1, 4
    vand    $v5, $v25, $v1[2]
    addi    $2, $0, 0x000C
    vand    $v6, $v24, $v1[3]
    sub     $14, $2, $14
    addi    $2, $14, -0x0001
    addi    $3, $0, 0x0001
    sll     $3, $3, 15
    srlv    $4, $3, $2
    mtc2    $4, $v22[0]
    lqv     $v21[0], 0x0000($13)
    lqv     $v20[0], 0x0010($13)
    addi    $13, $13, -0x0002
    lrv     $v19[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v18[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v17[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v16[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v15[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v14[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v13[0], 0x0020($13)
.L040015B4:
    addi    $20, $20, 0x0009
    vmudn   $v30, $v3, $v23
    addi    $21, $21, 0x0009
    vmadn   $v30, $v4, $v23
    ldv     $v1[0], 0x0000($20)
    vmudn   $v29, $v5, $v23
    lbu     $1, 0x0000($21)
    vmadn   $v29, $v6, $v23
    blez    $14, .L040015E4
    andi    $11, $1, 0x000F
    vmudm   $v30, $v30, $v22[0]
    vmudm   $v29, $v29, $v22[0]
.L040015E4:
    sll     $11, $11, 5
    vand    $v3, $v25, $v1[0]
    add     $13, $11, $15
    vand    $v4, $v24, $v1[1]
    vand    $v5, $v25, $v1[2]
    vand    $v6, $v24, $v1[3]
    srl     $14, $1, 4
    vmudh   $v2, $v21, $v27[6]
    addi    $2, $0, 0x000C
    vmadh   $v2, $v20, $v27[7]
    sub     $14, $2, $14
    vmadh   $v2, $v19, $v30[0]
    addi    $2, $14, -0x0001
    vmadh   $v2, $v18, $v30[1]
    addi    $3, $0, 0x0001
    vmadh   $v2, $v17, $v30[2]
    sll     $3, $3, 15
    vmadh   $v2, $v16, $v30[3]
    srlv    $4, $3, $2
    vmadh   $v28, $v15, $v30[4]
    mtc2    $4, $v22[0]
    vmadh   $v2, $v14, $v30[5]
    vmadh   $v2, $v13, $v30[6]
    vmadh   $v2, $v30, $v31[5]
    vsar    $v26, $v7, $v28[1]
    vsar    $v28, $v7, $v28[0]
    vmudn   $v2, $v26, $v31[4]
    vmadh   $v28, $v28, $v31[4]
    vmudh   $v2, $v19, $v29[0]
    addi    $12, $13, -0x0002
    vmadh   $v2, $v18, $v29[1]
    lrv     $v19[0], 0x0020($12)
    vmadh   $v2, $v17, $v29[2]
    addi    $12, $12, -0x0002
    vmadh   $v2, $v16, $v29[3]
    lrv     $v18[0], 0x0020($12)
    vmadh   $v2, $v15, $v29[4]
    addi    $12, $12, -0x0002
    vmadh   $v2, $v14, $v29[5]
    lrv     $v17[0], 0x0020($12)
    vmadh   $v2, $v13, $v29[6]
    addi    $12, $12, -0x0002
    vmadh   $v2, $v29, $v31[5]
    lrv     $v16[0], 0x0020($12)
    vmadh   $v2, $v21, $v28[6]
    addi    $12, $12, -0x0002
    vmadh   $v2, $v20, $v28[7]
    lrv     $v15[0], 0x0020($12)
    vsar    $v26, $v7, $v27[1]
    addi    $12, $12, -0x0002
    vsar    $v27, $v7, $v27[0]
    lrv     $v14[0], 0x0020($12)
    addi    $12, $12, -0x0002
    lrv     $v13[0], 0x0020($12)
    lqv     $v21[0], 0x0000($13)
    vmudn   $v2, $v26, $v31[4]
    lqv     $v20[0], 0x0010($13)
    vmadh   $v27, $v27, $v31[4]
    addi    $18, $18, -0x0020
    sdv     $v28[0], 0x0000($19)
    sdv     $v28[8], 0x0008($19)
    sdv     $v27[0], 0x0010($19)
    sdv     $v27[8], 0x0018($19)
    bgtz    $18, .L040015B4
    addi    $19, $19, 0x0020
.L040016E8:
    addi    $1, $19, -0x0020
    addi    $2, $17, 0x0000
    jal     dma_write
    addi    $3, $0, 0x001F
.L040016F8:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L040016F8
    nop
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_POLEF:
    lqv     $v31[0], 0x0000($0)
    vxor    $v28, $v28, $v28
    lhu     $21, 0x0000($24)
    vxor    $v17, $v17, $v17
    lhu     $20, 0x0002($24)
    vxor    $v18, $v18, $v18
    lhu     $19, 0x0004($24)
    vxor    $v19, $v19, $v19
    beqz    $19, .L04001874
    andi    $14, $26, 0xFFFF
    mtc2    $14, $v31[10]
    sll     $14, $14, 2
    mtc2    $14, $v16[0]
    lui     $1, 0x00FFFFFF >> 16
    vxor    $v20, $v20, $v20
    ori     $1, 0x00FFFFFF & 0xFFFF
    vxor    $v21, $v21, $v21
    and     $18, $25, $1
    vxor    $v22, $v22, $v22
    srl     $2, $25, 24
    vxor    $v23, $v23, $v23
    sll     $2, $2, 2
    lw      $3, 0x0320($2)
    add     $18, $18, $3
    slv     $v28[0], 0x0000($23)
    srl     $1, $26, 16
    andi    $1, $1, 0x0001
    bgtz    $1, .L040017A0
    nop
    addi    $1, $23, 0x0000
    addi    $2, $18, 0x0000
    jal     dma_read
    addi    $3, $0, 0x0007
.L04001790:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L04001790
    nop
    mtc0    $0, SP_SEMAPHORE
.L040017A0:
    addi    $13, $0, 0x04C0
    addi    $1, $0, 0x0004
    mtc2    $1, $v14[0]
    lqv     $v24[0], 0x0010($13)
    vmudm   $v16, $v24, $v16[0]
    ldv     $v28[8], 0x0000($23)
    sqv     $v16[0], 0x0010($13)
    lqv     $v25[0], 0x0000($13)
    addi    $13, $13, -0x0002
    lrv     $v23[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v22[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v21[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v20[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v19[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v18[0], 0x0020($13)
    addi    $13, $13, -0x0002
    lrv     $v17[0], 0x0020($13)
    ldv     $v30[0], 0x0000($21)
    ldv     $v30[8], 0x0008($21)
.L04001800:
    vmudh   $v16, $v25, $v28[6]
    addi    $21, $21, 0x0010
    vmadh   $v16, $v24, $v28[7]
    addi    $19, $19, -0x0010
    vmadh   $v16, $v23, $v30[0]
    vmadh   $v16, $v22, $v30[1]
    vmadh   $v16, $v21, $v30[2]
    vmadh   $v16, $v20, $v30[3]
    vmadh   $v28, $v19, $v30[4]
    vmadh   $v16, $v18, $v30[5]
    vmadh   $v16, $v17, $v30[6]
    vmadh   $v16, $v30, $v31[5]
    ldv     $v30[0], 0x0000($21)
    vsar    $v26, $v15, $v28[1]
    ldv     $v30[8], 0x0008($21)
    vsar    $v28, $v15, $v28[0]
    vmudn   $v16, $v26, $v14[0]
    vmadh   $v28, $v28, $v14[0]
    sdv     $v28[0], 0x0000($20)
    sdv     $v28[8], 0x0008($20)
    bgtz    $19, .L04001800
    addi    $20, $20, 0x0010
    addi    $1, $20, -0x0008
    addi    $2, $18, 0x0000
    jal     dma_write
    addi    $3, $0, 0x0007
.L04001868:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L04001868
    nop
.L04001874:
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_RESAMPLE:
    lh      $8, 0x0000($24)
    lh      $19, 0x0002($24)
    lh      $18, 0x0004($24)
    lui     $4, 0x00FFFFFF >> 16
    ori     $4, 0x00FFFFFF & 0xFFFF
    and     $2, $25, $4
    srl     $5, $25, 24
    sll     $5, $5, 2
    lw      $6, 0x0320($5)
    add     $2, $2, $6
    addi    $1, $23, 0x0000
    sw      $2, 0x0040($23)
    addi    $3, $0, 0x001F
    srl     $7, $26, 16
    andi    $10, $7, 0x0001
    bgtz    $10, .L040018DC
    nop
    jal     dma_read
    nop
.L040018C8:
    mfc0    $1, SP_DMA_BUSY
    bnez    $1, .L040018C8
    nop
    j       .L040018E8
    mtc0    $0, SP_SEMAPHORE
.L040018DC:
    sh      $0, 0x0008($23)
    vxor    $v16, $v16, $v16
    sdv     $v16[0], 0x0000($23)
.L040018E8:
    andi    $10, $7, 0x0002
    beqz    $10, .L04001908
    nop
    lh      $11, 0x000A($23)
    lqv     $v3[0], 0x0010($23)
    sdv     $v3[0], -0x0010($8)
    sdv     $v3[8], -0x0008($8)
    sub     $8, $8, $11
.L04001908:
    addi    $8, $8, -0x0008
    lsv     $v23[14], 0x0008($23)
    ldv     $v16[0], 0x0000($23)
    sdv     $v16[0], 0x0000($8)
    mtc2    $8, $v18[4]
    addi    $10, $0, 0x00C0
    mtc2    $10, $v18[6]
    mtc2    $26, $v18[8]
    addi    $10, $0, 0x0040
    mtc2    $10, $v18[10]
    addi    $9, $0, 0x0040
    lqv     $v31[0], 0x0010($9)
    lqv     $v25[0], 0x0000($9)
    vsub    $v25, $v25, $v31
    lqv     $v30[0], 0x0020($9)
    lqv     $v29[0], 0x0030($9)
    lqv     $v28[0], 0x0040($9)
    lqv     $v27[0], 0x0050($9)
    lqv     $v26[0], 0x0060($9)
    vsub    $v25, $v25, $v31
    lqv     $v24[0], 0x0070($9)
    addi    $21, $23, 0x0020
    addi    $20, $23, 0x0030
    vxor    $v22, $v22, $v22
    vmudm   $v23, $v31, $v23[7]
    vmadm   $v22, $v25, $v18[4]
    vmadn   $v23, $v31, $v30[0]
    vmudn   $v21, $v31, $v18[2]
    vmadn   $v21, $v22, $v30[2]
    vmudl   $v17, $v23, $v18[5]
    vmudn   $v17, $v17, $v30[4]
    vmadn   $v17, $v31, $v18[3]
    lqv     $v25[0], 0x0000($9)
    sqv     $v21[0], 0x0000($21)
    sqv     $v17[0], 0x0000($20)
    ssv     $v23[7], 0x0008($23)
    lh      $17, 0x0000($21)
    lh      $9, 0x0000($20)
    lh      $13, 0x0008($21)
    lh      $5, 0x0008($20)
    lh      $16, 0x0002($21)
    lh      $8, 0x0002($20)
    lh      $12, 0x000A($21)
    lh      $4, 0x000A($20)
    lh      $15, 0x0004($21)
    lh      $7, 0x0004($20)
    lh      $11, 0x000C($21)
    lh      $3, 0x000C($20)
    lh      $14, 0x0006($21)
    lh      $6, 0x0006($20)
    lh      $10, 0x000E($21)
    lh      $2, 0x000E($20)
.L040019D8:
    ldv     $v16[0], 0x0000($17)
    vmudm   $v23, $v31, $v23[7]
    ldv     $v15[0], 0x0000($9)
    vmadh   $v23, $v31, $v22[7]
    ldv     $v16[8], 0x0000($13)
    vmadm   $v22, $v25, $v18[4]
    ldv     $v15[8], 0x0000($5)
    vmadn   $v23, $v31, $v30[0]
    ldv     $v14[0], 0x0000($16)
    vmudn   $v21, $v31, $v18[2]
    ldv     $v13[0], 0x0000($8)
    vmadn   $v21, $v22, $v30[2]
    ldv     $v14[8], 0x0000($12)
    vmudl   $v17, $v23, $v18[5]
    ldv     $v13[8], 0x0000($4)
    ldv     $v12[0], 0x0000($15)
    ldv     $v11[0], 0x0000($7)
    ldv     $v12[8], 0x0000($11)
    vmudn   $v17, $v17, $v30[4]
    ldv     $v11[8], 0x0000($3)
    ldv     $v10[0], 0x0000($14)
    ldv     $v9[0], 0x0000($6)
    vmadn   $v17, $v31, $v18[3]
    ldv     $v10[8], 0x0000($10)
    vmulf   $v8, $v16, $v15
    ldv     $v9[8], 0x0000($2)
    vmulf   $v7, $v14, $v13
    sqv     $v21[0], 0x0000($21)
    vmulf   $v6, $v12, $v11
    sqv     $v17[0], 0x0000($20)
    lh      $17, 0x0000($21)
    vmulf   $v5, $v10, $v9
    lh      $9, 0x0000($20)
    vadd    $v8, $v8, $v8[1q]
    lh      $13, 0x0008($21)
    vadd    $v7, $v7, $v7[1q]
    lh      $5, 0x0008($20)
    vadd    $v6, $v6, $v6[1q]
    lh      $16, 0x0002($21)
    vadd    $v5, $v5, $v5[1q]
    lh      $8, 0x0002($20)
    vadd    $v8, $v8, $v8[2h]
    lh      $12, 0x000A($21)
    vadd    $v7, $v7, $v7[2h]
    lh      $4, 0x000A($20)
    vadd    $v6, $v6, $v6[2h]
    lh      $15, 0x0004($21)
    vadd    $v5, $v5, $v5[2h]
    lh      $7, 0x0004($20)
    vmudn   $v4, $v29, $v8[0h]
    lh      $11, 0x000C($21)
    vmadn   $v4, $v28, $v7[0h]
    lh      $3, 0x000C($20)
    vmadn   $v4, $v27, $v6[0h]
    lh      $14, 0x0006($21)
    vmadn   $v4, $v26, $v5[0h]
    lh      $6, 0x0006($20)
    lh      $10, 0x000E($21)
    addi    $18, $18, -0x0010
    sqv     $v4[0], 0x0000($19)
    blez    $18, .L04001AD8
    lh      $2, 0x000E($20)
    j       .L040019D8
    addi    $19, $19, 0x0010
.L04001AD8:
    ssv     $v23[0], 0x0008($23)
    ldv     $v16[0], 0x0000($17)
    sdv     $v16[0], 0x0000($23)
    lh      $6, 0x0000($24)
    addi    $17, $17, 0x0008
    sub     $5, $17, $6
    andi    $4, $5, 0x000F
    sub     $17, $17, $4
    beqz    $4, .L04001B04
    addi    $7, $0, 0x0010
    sub     $4, $7, $4
.L04001B04:
    sh      $4, 0x000A($23)
    ldv     $v3[0], 0x0000($17)
    ldv     $v3[8], 0x0008($17)
    sqv     $v3[0], 0x0010($23)
    lw      $2, 0x0040($23)
    addi    $1, $23, 0x0000
    jal     dma_write
    addi    $3, $0, 0x001F
.L04001B24:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L04001B24
    nop
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_ENVMIXER:
    lui     $4, 0x00FFFFFF >> 16
    ori     $4, 0x00FFFFFF & 0xFFFF
    and     $2, $25, $4
    srl     $5, $25, 24
    sll     $5, $5, 2
    lw      $6, 0x0320($5)
    add     $2, $2, $6
    addi    $1, $23, 0x0000
    addi    $3, $0, 0x004F
    vxor    $v0, $v0, $v0
    addi    $11, $0, 0x0040
    lqv     $v31[0], 0x0010($11)
    lqv     $v10[0], 0x0000($0)
    srl     $12, $26, 16
    andi    $10, $12, 0x0001
    beqz    $10, .L04001B84
    lqv     $v24[0], 0x0010($24)
    j       .L04001BB0
    nop
.L04001B84:
    jal     dma_read
    nop
.L04001B8C:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L04001B8C
    nop
    mtc0    $0, SP_SEMAPHORE
    lqv     $v20[0], 0x0000($23)
    lqv     $v21[0], 0x0010($23)
    lqv     $v18[0], 0x0020($23)
    lqv     $v19[0], 0x0030($23)
    lqv     $v24[0], 0x0040($23)
.L04001BB0:
    lh      $13, 0x0000($24)
    lh      $19, 0x0002($24)
    lh      $18, 0x000A($24)
    lh      $17, 0x000C($24)
    lh      $16, 0x000E($24)
    lh      $14, 0x0004($24)
    addi    $15, $0, 0x0010
    mfc2    $21, $v24[2]
    mfc2    $20, $v24[8]
    andi    $9, $12, 0x0008
    bgtz    $9, .L04001BEC
    nop
    addi    $17, $23, 0x0050
    add     $16, $0, $17
    addi    $15, $0, 0x0000
.L04001BEC:
    beqz    $10, .L04001CF0
    lqv     $v30[0], 0x0070($11)
    lqv     $v17[0], 0x0000($13)
    lqv     $v29[0], 0x0000($19)
    lqv     $v27[0], 0x0000($17)
    vxor    $v21, $v21, $v21
    lsv     $v20[14], 0x0006($24)
    vmudm   $v23, $v20, $v24[2]
    vmadh   $v22, $v20, $v24[1]
    vmadn   $v23, $v31, $v0[0]
    vsubc   $v23, $v23, $v21
    vsub    $v22, $v22, $v20
    vmudl   $v23, $v30, $v23[7]
    vmadn   $v23, $v30, $v22[7]
    vmadm   $v22, $v31, $v0[0]
    vmadm   $v21, $v31, $v21[7]
    vmadh   $v20, $v31, $v20[7]
    bgtz    $21, .L04001C44
    vmadn   $v21, $v31, $v0[0]
    vge     $v20, $v20, $v24[0]
    j       .L04001C48
    nop
.L04001C44:
    vcl     $v20, $v20, $v24[0]
.L04001C48:
    vmulf   $v16, $v20, $v24[6]
    vmulf   $v15, $v20, $v24[7]
    vmulf   $v29, $v29, $v10[6]
    vmacf   $v29, $v17, $v16
    vmulf   $v27, $v27, $v10[6]
    vmacf   $v27, $v17, $v15
    sqv     $v29[0], 0x0000($19)
    sqv     $v27[0], 0x0000($17)
    lqv     $v28[0], 0x0000($18)
    lqv     $v26[0], 0x0000($16)
    vxor    $v19, $v19, $v19
    lsv     $v18[14], 0x0008($24)
    vmudm   $v23, $v18, $v24[5]
    vmadh   $v22, $v18, $v24[4]
    vmadn   $v23, $v31, $v0[0]
    vsubc   $v23, $v23, $v19
    vsub    $v22, $v22, $v18
    vmudl   $v23, $v30, $v23[7]
    vmadn   $v23, $v30, $v22[7]
    vmadm   $v22, $v31, $v0[0]
    vmadm   $v19, $v31, $v19[7]
    vmadh   $v18, $v31, $v18[7]
    bgtz    $20, .L04001CB4
    vmadn   $v19, $v31, $v0[0]
    vge     $v18, $v18, $v24[3]
    j       .L04001CB8
    nop
.L04001CB4:
    vcl     $v18, $v18, $v24[3]
.L04001CB8:
    vmulf   $v16, $v18, $v24[6]
    vmulf   $v15, $v18, $v24[7]
    vmulf   $v28, $v28, $v10[6]
    vmacf   $v28, $v17, $v16
    vmulf   $v26, $v26, $v10[6]
    vmacf   $v26, $v17, $v15
    sqv     $v28[0], 0x0000($18)
    sqv     $v26[0], 0x0000($16)
    addi    $14, $14, -0x0010
    addi    $13, $13, 0x0010
    addi    $19, $19, 0x0010
    addi    $18, $18, 0x0010
    add     $17, $17, $15
    add     $16, $16, $15
.L04001CF0:
    vmudl   $v23, $v21, $v24[2]
    vmadm   $v23, $v20, $v24[2]
    vmadn   $v23, $v21, $v24[1]
    vmadh   $v20, $v20, $v24[1]
    vmadn   $v21, $v31, $v0[0]
.L04001D04:
    bgtz    $21, .L04001D30
    lqv     $v17[0], 0x0000($13)
    vge     $v20, $v20, $v24[0]
    vmudl   $v23, $v19, $v24[5]
    vmadm   $v23, $v18, $v24[5]
    vmadn   $v23, $v19, $v24[4]
    lqv     $v29[0], 0x0000($19)
    vmadh   $v18, $v18, $v24[4]
    lqv     $v27[0], 0x0000($17)
    j       .L04001D50
    vmadn   $v19, $v31, $v0[0]
.L04001D30:
    vcl     $v20, $v20, $v24[0]
    vmudl   $v23, $v19, $v24[5]
    vmadm   $v23, $v18, $v24[5]
    vmadn   $v23, $v19, $v24[4]
    lqv     $v29[0], 0x0000($19)
    vmadh   $v18, $v18, $v24[4]
    lqv     $v27[0], 0x0000($17)
    vmadn   $v19, $v31, $v0[0]
.L04001D50:
    vmulf   $v16, $v20, $v24[6]
    sqv     $v20[0], 0x0000($23)
    vmulf   $v15, $v20, $v24[7]
    sqv     $v21[0], 0x0010($23)
    vmulf   $v29, $v29, $v10[6]
    vmacf   $v29, $v17, $v16
    lqv     $v28[0], 0x0000($18)
    vmulf   $v27, $v27, $v10[6]
    lqv     $v26[0], 0x0000($16)
    vmacf   $v27, $v17, $v15
    bgtz    $20, .L04001DA0
    sqv     $v29[0], 0x0000($19)
    vge     $v18, $v18, $v24[3]
    vmudl   $v23, $v21, $v24[2]
    sqv     $v27[0], 0x0000($17)
    vmadm   $v23, $v20, $v24[2]
    vmadn   $v23, $v21, $v24[1]
    vmadh   $v20, $v20, $v24[1]
    j       .L04001DBC
    vmadn   $v21, $v31, $v0[0]
.L04001DA0:
    vcl     $v18, $v18, $v24[3]
    vmudl   $v23, $v21, $v24[2]
    sqv     $v27[0], 0x0000($17)
    vmadm   $v23, $v20, $v24[2]
    vmadn   $v23, $v21, $v24[1]
    vmadh   $v20, $v20, $v24[1]
    vmadn   $v21, $v31, $v0[0]
.L04001DBC:
    vmulf   $v16, $v18, $v24[6]
    addi    $14, $14, -0x0010
    vmulf   $v15, $v18, $v24[7]
    addi    $19, $19, 0x0010
    vmulf   $v28, $v28, $v10[6]
    add     $17, $17, $15
    vmacf   $v28, $v17, $v16
    addi    $13, $13, 0x0010
    vmulf   $v26, $v26, $v10[6]
    vmacf   $v26, $v17, $v15
    sqv     $v28[0], 0x0000($18)
    addi    $18, $18, 0x0010
    blez    $14, .L04001DFC
    sqv     $v26[0], 0x0000($16)
    j       .L04001D04
    add     $16, $16, $15
.L04001DFC:
    sqv     $v18[0], 0x0020($23)
    sqv     $v19[0], 0x0030($23)
    sqv     $v24[0], 0x0040($23)
    jal     dma_write
    addi    $3, $0, 0x004F
.L04001E10:
    mfc0    $5, SP_DMA_BUSY
    bnez    $5, .L04001E10
    nop
    j       cmd_next
    mtc0    $0, SP_SEMAPHORE

case_A_MIXER:
    lqv     $v31[0], 0x0000($0)
    lhu     $18, 0x0004($24)
    beqz    $18, .L04001E94
    nop
    andi    $19, $25, 0xFFFF
    addi    $19, $19, 0x05C0
    srl     $20, $25, 16
    addi    $20, $20, 0x05C0
    andi    $17, $26, 0xFFFF
    mtc2    $17, $v30[0]
    lqv     $v27[0], 0x0000($19)
    lqv     $v29[0], 0x0000($20)
    lqv     $v26[0], 0x0010($19)
    lqv     $v28[0], 0x0010($20)
.L04001E5C:
    vmulf   $v27, $v27, $v31[6]
    addi    $18, $18, -0x0020
    vmacf   $v27, $v29, $v30[0]
    addi    $20, $20, 0x0020
    sqv     $v27[0], 0x0000($19)
    vmulf   $v26, $v26, $v31[6]
    lqv     $v29[0], 0x0000($20)
    vmacf   $v26, $v28, $v30[0]
    lqv     $v28[0], 0x0010($20)
    sqv     $v26[0], 0x0010($19)
    addi    $19, $19, 0x0020
    lqv     $v27[0], 0x0000($19)
    bgtz    $18, .L04001E5C
    lqv     $v26[0], 0x0010($19)
.L04001E94:
    j       cmd_next
    nop

.align 8

.close

.create "build/src/PR/aspMain.data.bin", 0

    .word 0x00000001, 0x0002FFFF, 0x00200800, 0x7FFF4000
    .half cmd_next
    .half case_A_ADPCM
    .half case_A_CLEARBUFF
    .half case_A_ENVMIXER
    .half case_A_LOADBUFF
    .half case_A_RESAMPLE
    .half case_A_SAVEBUFF
    .half case_A_SEGMENT
    .half case_A_SETBUFF
    .half case_A_SETVOL
    .half case_A_DMEMMOVE
    .half case_A_LOADADPCM
    .half case_A_MIXER
    .half case_A_INTERLEAVE
    .half case_A_POLEF
    .half case_A_SETLOOP
    .word 0xF0000F00, 0x00F0000F, 0x00010010, 0x01001000
    .word 0x00020004, 0x00060008, 0x000A000C, 0x000E0010
    .word 0x00010001, 0x00010001, 0x00010001, 0x00010001
    .word 0x00000001, 0x00020004, 0x00080010, 0x01000200
    .word 0x00010000, 0x00000000, 0x00010000, 0x00000000
    .word 0x00000001, 0x00000000, 0x00000001, 0x00000000
    .word 0x00000000, 0x00010000, 0x00000000, 0x00010000
    .word 0x00000000, 0x00000001, 0x00000000, 0x00000001
    .word 0x20004000, 0x60008000, 0xA000C000, 0xE000FFFF
    .word 0x0C3966AD, 0x0D46FFDF, 0x0B396696, 0x0E5FFFD8
    .word 0x0A446669, 0x0F83FFD0, 0x095A6626, 0x10B4FFC8
    .word 0x087D65CD, 0x11F0FFBF, 0x07AB655E, 0x1338FFB6
    .word 0x06E464D9, 0x148CFFAC, 0x0628643F, 0x15EBFFA1
    .word 0x0577638F, 0x1756FF96, 0x04D162CB, 0x18CBFF8A
    .word 0x043561F3, 0x1A4CFF7E, 0x03A46106, 0x1BD7FF71
    .word 0x031C6007, 0x1D6CFF64, 0x029F5EF5, 0x1F0BFF56
    .word 0x022A5DD0, 0x20B3FF48, 0x01BE5C9A, 0x2264FF3A
    .word 0x015B5B53, 0x241EFF2C, 0x010159FC, 0x25E0FF1E
    .word 0x00AE5896, 0x27A9FF10, 0x00635720, 0x297AFF02
    .word 0x001F559D, 0x2B50FEF4, 0xFFE2540D, 0x2D2CFEE8
    .word 0xFFAC5270, 0x2F0DFEDB, 0xFF7C50C7, 0x30F3FED0
    .word 0xFF534F14, 0x32DCFEC6, 0xFF2E4D57, 0x34C8FEBD
    .word 0xFF0F4B91, 0x36B6FEB6, 0xFEF549C2, 0x38A5FEB0
    .word 0xFEDF47ED, 0x3A95FEAC, 0xFECE4611, 0x3C85FEAB
    .word 0xFEC04430, 0x3E74FEAC, 0xFEB6424A, 0x4060FEAF
    .word 0xFEAF4060, 0x424AFEB6, 0xFEAC3E74, 0x4430FEC0
    .word 0xFEAB3C85, 0x4611FECE, 0xFEAC3A95, 0x47EDFEDF
    .word 0xFEB038A5, 0x49C2FEF5, 0xFEB636B6, 0x4B91FF0F
    .word 0xFEBD34C8, 0x4D57FF2E, 0xFEC632DC, 0x4F14FF53
    .word 0xFED030F3, 0x50C7FF7C, 0xFEDB2F0D, 0x5270FFAC
    .word 0xFEE82D2C, 0x540DFFE2, 0xFEF42B50, 0x559D001F
    .word 0xFF02297A, 0x57200063, 0xFF1027A9, 0x589600AE
    .word 0xFF1E25E0, 0x59FC0101, 0xFF2C241E, 0x5B53015B
    .word 0xFF3A2264, 0x5C9A01BE, 0xFF4820B3, 0x5DD0022A
    .word 0xFF561F0B, 0x5EF5029F, 0xFF641D6C, 0x6007031C
    .word 0xFF711BD7, 0x610603A4, 0xFF7E1A4C, 0x61F30435
    .word 0xFF8A18CB, 0x62CB04D1, 0xFF961756, 0x638F0577
    .word 0xFFA115EB, 0x643F0628, 0xFFAC148C, 0x64D906E4
    .word 0xFFB61338, 0x655E07AB, 0xFFBF11F0, 0x65CD087D
    .word 0xFFC810B4, 0x6626095A, 0xFFD00F83, 0x66690A44
    .word 0xFFD80E5F, 0x66960B39, 0xFFDF0D46, 0x66AD0C39

.align 8

.close
