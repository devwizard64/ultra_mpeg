.create "build/src/PR/gspFast3D.fifo.clip.bin", 0
.base prg_ext_start

@clip:
    b       clip
    sh      $ra, 0x0158($0)
    nop

@light:
    nop
    ori     $30, $0, 0x0018
    b       prg_jump
    lh      $21, 0x00A0($0)

clip:
    sh      $3, 0x0940($0)
    sh      $2, 0x0942($0)
    sh      $1, 0x0944($0)
    sh      $0, 0x0946($0)
    ori     $7, $0, 0x0DB8
    ori     $30, $0, 0x0940
    ori     $6, $0, 0x000C

ProcClipNext:
    or      $5, $30, $30
    xori    $30, $30, 0x0014
.L040017A8:
    beqz    $6, .L04001954
    lh      $11, 0x00A6($6)
    addi    $6, $6, -0x0002
    ori     $17, $0, 0x0000
    or      $18, $0, $0

ProcClipI:
    ori     $2, $5, 0x0000

ProcClipO:
    j       .L040017D4
    addi    $14, $30, 0x0002
.L040017C8:
    and     $8, $8, $11
    beq     $8, $18, .L04001804_2
    addi    $2, $2, 0x0002
.L040017D4:
    or      $20, $10, $0
    sh      $10, 0x0000($14)
    addi    $14, $14, 0x0002
.L040017E0:
    lh      $10, 0x0000($2)
    bnez    $10, .L040017C8
    lh      $8, 0x0024($10)
    addi    $8, $17, -0x0002
    bgtz    $8, .L040017E0
    ori     $2, $5, 0x0000
    beqz    $8, .L040017A8
    nop
    j       _04001980
.L04001804_2:
    xor     $18, $18, $11
    lh      $8, 0x00F6($17)
    addi    $17, $17, 0x0002
    jr      $8
    lh      $8, 0x0102($0)

ProcClipFI:
    mtc2    $10, $v13[0]
    or      $10, $20, $0
    mfc2    $20, $v13[0]
    ori     $14, $30, 0x0000
    lh      $8, 0x00F8($0)

ProcClipFO:
    sh      $8, 0x0106($0)
    addi    $7, $7, 0x0028
    sh      $7, 0x0000($14)
    sh      $0, 0x0002($14)
    ldv     $v9[0], 0x0000($10)
    ldv     $v10[0], 0x0008($10)
    ldv     $v4[0], 0x0000($20)
    ldv     $v5[0], 0x0008($20)
    sll     $8, $6, 2
    ldv     $v1[0], 0x0070($8)
    vmudh   $v0, $v1, $v31[3]
    vmudn   $v12, $v5, $v1
    vmadh   $v11, $v4, $v1
    vmadn   $v12, $v31, $v31[0]
    vmadn   $v28, $v10, $v0
    vmadh   $v29, $v9, $v0
    vmadn   $v28, $v31, $v31[0]
    vaddc   $v26, $v28, $v28[0q]
    vadd    $v27, $v29, $v29[0q]
    vaddc   $v28, $v26, $v26[1h]
    vadd    $v29, $v27, $v27[1h]
    mfc2    $8, $v29[6]
    vrcph   $v7[3], $v29[3]
    vrcpl   $v3[3], $v28[3]
    vrcph   $v7[3], $v31[0]
    vmudn   $v3, $v3, $v31[2]
    bgez    $8, .L040018A4
    vmadh   $v7, $v7, $v31[2]
    vmudn   $v3, $v3, $v31[3]
    vmadh   $v7, $v7, $v31[3]
.L040018A4:
    veq     $v7, $v7, $v31[0]
    vmrg    $v3, $v3, $v31[3]
    vmudl   $v28, $v28, $v3[3]
    vmadm   $v29, $v29, $v3[3]
    jal     prg_main_start
    vmadn   $v28, $v31, $v31[0]
    vaddc   $v28, $v12, $v12[0q]
    vadd    $v29, $v11, $v11[0q]
    vaddc   $v12, $v28, $v28[1h]
    vadd    $v11, $v29, $v29[1h]
    vmudl   $v15, $v12, $v26
    vmadm   $v15, $v11, $v26
    vmadn   $v15, $v12, $v27
    vmadh   $v8, $v11, $v27
    vmudl   $v28, $v31, $v31[5]
    vmadl   $v15, $v15, $v3[3]
    vmadm   $v8, $v8, $v3[3]
    vmadn   $v15, $v31, $v31[0]
    veq     $v8, $v8, $v31[0]
    vmrg    $v15, $v15, $v31[3]
    vne     $v15, $v15, $v31[0]
    vmrg    $v15, $v15, $v31[1]
    vnxor   $v8, $v15, $v31[0]
    vaddc   $v8, $v8, $v31[1]
    vadd    $v29, $v29, $v29
    vmudl   $v28, $v5, $v8[3h]
    vmadm   $v29, $v4, $v8[3h]
    vmadl   $v28, $v10, $v15[3h]
    vmadm   $v29, $v9, $v15[3h]
    vmadn   $v28, $v31, $v31[0]
    luv     $v12[0], 0x0010($10)
    luv     $v11[0], 0x0010($20)
    llv     $v12[8], 0x0014($10)
    llv     $v11[8], 0x0014($20)
    vmudm   $v18, $v12, $v15[3]
    vmadm   $v18, $v11, $v8[3]
    suv     $v18[0], 0x0000($7)
    sdv     $v18[8], 0x0008($7)
    ldv     $v18[0], 0x0008($7)
    jal     _040014E8
    lw      $15, 0x0000($7)
    mfc2    $10, $v13[0]
    j       .vtx_clip_return
    ori     $9, $0, 0x0001
.L04001954:
    lh      $8, 0x0000($5)
    sh      $8, 0x00B4($0)
    sh      $5, 0x0106($0)
    lh      $30, 0x00FE($0)

ProcClipDraw:
    lh      $8, 0x0106($0)
    lh      $3, 0x00B4($0)
    lh      $2, 0x0002($8)
    lh      $1, 0x0004($8)
    addi    $8, $8, 0x0002
    bnez    $1, .clip_return
    sh      $8, 0x0106($0)

_04001980:
    j       cmd_next
    nop

.align 8
prg_clip_end:

.close
