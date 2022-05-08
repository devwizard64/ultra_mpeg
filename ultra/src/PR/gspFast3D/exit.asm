.create "build/src/PR/gspFast3D.fifo.exit.bin", 0
.base prg_ext_start

@yield:
    j       yield
    nop

exit:
    nop
    jal     dma_sync
    ori     $2, $0, 0x4000
    mtc0    $2, SP_STATUS
    break   0
    nop

yield:
    ori     $2, $0, 0x1000
    sw      $28, 0x08E4($0)
    sw      $27, 0x08E8($0)
    sw      $26, 0x08EC($0)
    sw      $23, 0x08F0($0)
    lw      $19, 0x0108($0)
    ori     $20, $0, 0x0000
    ori     $18, $0, 0x08FF
    jal     dma_start
    ori     $17, $0, 0x0001
    jal     dma_sync
    nop
    j       task_exit
    mtc0    $2, SP_STATUS
    nop
    nop
    addiu   $0, $0, 0xBEEF

.align 8
prg_exit_end:

.close
