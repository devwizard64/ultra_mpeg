.create "build/src/PR/gspFast3D.fifo.light.bin", 0
.base prg_ext_start

@clip:
    ori     $30, $0, 0x0010
    b       prg_jump
    lh      $21, 0x0100($0)

light:
    lw      $1, 0x012C($0)
    sw      $15, 0x0000($7)
    sw      $16, 0x0004($7)
    bltz    $1, .L0400180C
    lpv     $v4[0], 0x0000($7)
    luv     $v7[0], 0x01D0($1)
    vxor    $v27, $v27, $v27
.L04001790:
    vge     $v7, $v7, $v31[0]
    lpv     $v5[0], 0x01C0($1)
    vadd    $v27, $v27, $v7
    luv     $v7[0], 0x01B0($1)
    vor     $v20, $v6, $v31[0]
    vmulf   $v6, $v4, $v5
    vadd    $v3, $v6, $v6[1q]
    vadd    $v6, $v3, $v6[2h]
    vmulf   $v7, $v7, $v6[0h]
    bgtz    $1, .L04001790
    addi    $1, $1, -0x0020
    suv     $v27[0], 0x0000($7)
    andi    $8, $3, 0x0004
    sb      $15, 0x0003($7)
    sb      $16, 0x0007($7)
    lw      $15, 0x0000($7)
    beqz    $8, .light_return
    lw      $16, 0x0004($7)
    andi    $8, $3, 0x0008
    lpv     $v7[0], 0x0090($29)
    ldv     $v6[0], 0x00A0($0)
    vmadn   $v20, $v7, $v20[0h]
    beqz    $8, .L04001804_3
    vmadm   $v18, $v31, $v31[0]
    vmulf   $v7, $v18, $v18
    vmulf   $v7, $v7, $v18
    vmulf   $v20, $v7, $v6[1]
    vmacf   $v20, $v7, $v6[3]
    vmacf   $v18, $v18, $v6[2]
.L04001804_3:
    j       .light_return
    vadd    $v18, $v18, $v31[4]
.L0400180C:
    andi    $1, $1, 0x0FFF
    sw      $1, 0x012C($0)
    jal     _04001524
    addi    $8, $0, 0x0360
    ori     $8, $0, 0x0DE0
    stv     $v8[2], 0x0010($8)
    stv     $v8[4], 0x0020($8)
    stv     $v8[12], 0x0030($8)
    stv     $v8[14], 0x0040($8)
    ltv     $v8[14], 0x0010($8)
    ltv     $v8[12], 0x0020($8)
    ltv     $v8[4], 0x0030($8)
    ltv     $v8[2], 0x0040($8)
    sdv     $v12[8], 0x0010($8)
    sdv     $v13[8], 0x0020($8)
    sdv     $v14[8], 0x0030($8)
    ldv     $v12[0], 0x0010($8)
    ldv     $v13[0], 0x0020($8)
    ldv     $v14[0], 0x0030($8)
.L04001858:
    lpv     $v5[0], 0x01B8($1)
    vmulf   $v5, $v5, $v31[4]
    vmudn   $v6, $v12, $v5[0h]
    vmadn   $v6, $v13, $v5[1h]
    vmadn   $v6, $v14, $v5[2h]
    vmadm   $v3, $v31, $v31[0]
    vmudm   $v6, $v3, $v31[2]
    vmacf   $v3, $v8, $v5[0h]
    vmacf   $v3, $v9, $v5[1h]
    vmacf   $v3, $v10, $v5[2h]
    vmadn   $v6, $v31, $v31[0]
    vmudl   $v5, $v6, $v6
    vmadm   $v5, $v3, $v6
    vmadn   $v5, $v6, $v3
    vmadh   $v26, $v3, $v3
    vaddc   $v7, $v5, $v5[1q]
    vadd    $v4, $v26, $v26[1q]
    vaddc   $v7, $v5, $v7[0h]
    vadd    $v4, $v26, $v4[0h]
    vrsqh   $v11[0], $v4[2]
    vrsql   $v15[0], $v7[2]
    vrsqh   $v11[0], $v31[0]
    vmudl   $v15, $v15, $v30[3]
    vmadm   $v11, $v11, $v30[3]
    vmadn   $v15, $v31, $v31[0]
    vmudl   $v7, $v6, $v15[0]
    vmadm   $v7, $v3, $v15[0]
    vmadn   $v7, $v6, $v11[0]
    vmadh   $v4, $v3, $v11[0]
    vmadn   $v7, $v31, $v31[0]
    ldv     $v2[0], 0x00F8($29)
    vge     $v7, $v7, $v2[0]
    vlt     $v7, $v7, $v2[1]
    vmudn   $v7, $v7, $v2[2]
    spv     $v7[0], 0x01C0($1)
    lw      $8, 0x01C0($1)
    sw      $8, 0x01C4($1)
    bgtz    $1, .L04001858
    addi    $1, $1, -0x0020
    j       _04001510
    lh      $ra, 0x00A0($0)

.align 8
prg_light_end:

.close
