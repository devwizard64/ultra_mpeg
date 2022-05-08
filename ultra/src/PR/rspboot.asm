.include "src/PR/rsp.inc"

.create "build/src/PR/rspboot.text.bin", 0x04001000

    ori     $1, $1, 1
    j       main
    addi    $1, $0, os_task

boot:
    lw      $2, OSTask__ucode($1)
    addi    $3, $0, 0x0F80-1
    addi    $7, $0, 0x1080
    mtc0    $7, SP_MEM_ADDR
    mtc0    $2, SP_DRAM_ADDR
    mtc0    $3, SP_RD_LEN
@@dmabusy:
    mfc0    $4, SP_DMA_BUSY
    bnez    $4, @@dmabusy
    nop
    jal     yield_check
    nop
    jr      $7
    mtc0    $0, SP_SEMAPHORE

yield_check:
    mfc0    $8, SP_STATUS
    andi    $8, $8, SP_STATUS_YIELD
    bnez    $8, @@yield
    nop
    jr      $ra
@@yield:
    mtc0    $0, SP_SEMAPHORE
    ori     $8, $0, SP_CLR_YIELD | SP_SET_YIELDED | SP_SET_TASKDONE
    mtc0    $8, SP_STATUS
    break   0
    nop

main:
    lw      $2, OSTask__flags($1)
    andi    $2, $2, OS_TASK_DP_WAIT
    beqz    $2, @@nodpwait
    nop
    jal     yield_check
    nop
    mfc0    $2, DPC_STATUS
    andi    $2, $2, DPC_STATUS_DMA_BUSY
    bgtz    $2, yield_check
    nop
@@nodpwait:
    lw      $2, OSTask__ucode_data($1)
    lw      $3, OSTask__ucode_data_size($1)
    addi    $3, $3, -1
@@dmafull:
    mfc0    $30, SP_DMA_FULL
    bnez    $30, @@dmafull
    nop
    mtc0    $0, SP_MEM_ADDR
    mtc0    $2, SP_DRAM_ADDR
    mtc0    $3, SP_RD_LEN
@@dmabusy:
    mfc0    $4, SP_DMA_BUSY
    bnez    $4, @@dmabusy
    nop
    jal     yield_check
    nop
    j       boot
    nop

.align 8

.close
