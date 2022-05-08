.create "build/src/PR/gspFast3D.fifo.init.bin", 0x04001080

prg_init_start:

    j       init
    addi    $29, $0, 0x0110

.close
