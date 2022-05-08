.rsp

.half equ .halfword

.macro .base, addr
    .headersize (addr) - orga()
.endmacro

.macro .even
    .if (org() & 4) != 0
        nop
    .endif
.endmacro

.macro .odd
    .if (org() & 4) == 0
        nop
    .endif
.endmacro

SP_DMEM_START           equ 0x04000000
SP_DMEM_END             equ 0x04000FFF
SP_IMEM_START           equ 0x04001000
SP_IMEM_END             equ 0x04001FFF

SP_DMA_DMEM             equ 0x0000
SP_DMA_IMEM             equ 0x1000

SP_CLR_HALT             equ 0x00000001
SP_SET_HALT             equ 0x00000002
SP_CLR_BROKE            equ 0x00000004
SP_CLR_INTR             equ 0x00000008
SP_SET_INTR             equ 0x00000010
SP_CLR_SSTEP            equ 0x00000020
SP_SET_SSTEP            equ 0x00000040
SP_CLR_INTR_BREAK       equ 0x00000080
SP_SET_INTR_BREAK       equ 0x00000100
SP_CLR_SIG0             equ 0x00000200
SP_SET_SIG0             equ 0x00000400
SP_CLR_SIG1             equ 0x00000800
SP_SET_SIG1             equ 0x00001000
SP_CLR_SIG2             equ 0x00002000
SP_SET_SIG2             equ 0x00004000
SP_CLR_SIG3             equ 0x00008000
SP_SET_SIG3             equ 0x00010000
SP_CLR_SIG4             equ 0x00020000
SP_SET_SIG4             equ 0x00040000
SP_CLR_SIG5             equ 0x00080000
SP_SET_SIG5             equ 0x00100000
SP_CLR_SIG6             equ 0x00200000
SP_SET_SIG6             equ 0x00400000
SP_CLR_SIG7             equ 0x00800000
SP_SET_SIG7             equ 0x01000000

SP_STATUS_HALT          equ 0x0001
SP_STATUS_BROKE         equ 0x0002
SP_STATUS_DMA_BUSY      equ 0x0004
SP_STATUS_DMA_FULL      equ 0x0008
SP_STATUS_IO_FULL       equ 0x0010
SP_STATUS_SSTEP         equ 0x0020
SP_STATUS_INTR_BREAK    equ 0x0040
SP_STATUS_SIG0          equ 0x0080
SP_STATUS_SIG1          equ 0x0100
SP_STATUS_SIG2          equ 0x0200
SP_STATUS_SIG3          equ 0x0400
SP_STATUS_SIG4          equ 0x0800
SP_STATUS_SIG5          equ 0x1000
SP_STATUS_SIG6          equ 0x2000
SP_STATUS_SIG7          equ 0x4000

SP_CLR_YIELD            equ SP_CLR_SIG0
SP_SET_YIELD            equ SP_SET_SIG0
SP_STATUS_YIELD         equ SP_STATUS_SIG0
SP_CLR_YIELDED          equ SP_CLR_SIG1
SP_SET_YIELDED          equ SP_SET_SIG1
SP_STATUS_YIELDED       equ SP_STATUS_SIG1
SP_CLR_TASKDONE         equ SP_CLR_SIG2
SP_SET_TASKDONE         equ SP_SET_SIG2
SP_STATUS_TASKDONE      equ SP_STATUS_SIG2
SP_CLR_RSPSIGNAL        equ SP_CLR_SIG3
SP_SET_RSPSIGNAL        equ SP_SET_SIG3
SP_STATUS_RSPSIGNAL     equ SP_STATUS_SIG3
SP_CLR_CPUSIGNAL        equ SP_CLR_SIG4
SP_SET_CPUSIGNAL        equ SP_SET_SIG4
SP_STATUS_CPUSIGNAL     equ SP_STATUS_SIG4

DPC_CLR_XBUS_DMEM_DMA   equ 0x0001
DPC_SET_XBUS_DMEM_DMA   equ 0x0002
DPC_CLR_FREEZE          equ 0x0004
DPC_SET_FREEZE          equ 0x0008
DPC_CLR_FLUSH           equ 0x0010
DPC_SET_FLUSH           equ 0x0020
DPC_CLR_TMEM_CTR        equ 0x0040
DPC_CLR_PIPE_CTR        equ 0x0080
DPC_CLR_CMD_CTR         equ 0x0100
DPC_CLR_CLOCK_CTR       equ 0x0200

DPC_STATUS_XBUS_DMEM_DMA        equ 0x0001
DPC_STATUS_FREEZE               equ 0x0002
DPC_STATUS_FLUSH                equ 0x0004
DPC_STATUS_START_GCLK           equ 0x0008
DPC_STATUS_TMEM_BUSY            equ 0x0010
DPC_STATUS_PIPE_BUSY            equ 0x0020
DPC_STATUS_CMD_BUSY             equ 0x0040
DPC_STATUS_CBUF_READY           equ 0x0080
DPC_STATUS_DMA_BUSY             equ 0x0100
DPC_STATUS_END_VALID            equ 0x0200
DPC_STATUS_START_VALID          equ 0x0400

OS_TASK_YIELDED         equ 0x0001
OS_TASK_DP_WAIT         equ 0x0002
OS_TASK_LOADABLE        equ 0x0004
OS_TASK_SP_ONLY         equ 0x0008
OS_TASK_USR0            equ 0x0010
OS_TASK_USR1            equ 0x0020
OS_TASK_USR2            equ 0x0040
OS_TASK_USR3            equ 0x0080

OSTask__type                    equ 0x00
OSTask__flags                   equ 0x04
OSTask__ucode_boot              equ 0x08
OSTask__ucode_boot_size         equ 0x0C
OSTask__ucode                   equ 0x10
OSTask__ucode_size              equ 0x14
OSTask__ucode_data              equ 0x18
OSTask__ucode_data_size         equ 0x1C
OSTask__dram_stack              equ 0x20
OSTask__dram_stack_size         equ 0x24
OSTask__output_buff             equ 0x28
OSTask__output_buff_size        equ 0x2C
OSTask__data_ptr                equ 0x30
OSTask__data_size               equ 0x34
OSTask__yield_data_ptr          equ 0x38
OSTask__yield_data_size         equ 0x3C

.definelabel os_task,           0x0FC0
