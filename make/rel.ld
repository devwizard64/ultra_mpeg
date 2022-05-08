OUTPUT_ARCH(mips)
SECTIONS
{
    .interp                 0 : {*(.interp)}
    .MIPS.abiflags          0 : {*(.MIPS.abiflags)}
    .reginfo                0 : {*(.reginfo)}
    .MIPS.xhash             0 : {*(.MIPS.xhash)}
    .note.gnu.build-id      0 : {*(.note.gnu.build-id)}
    .dynamic                0 : {*(.dynamic)}
    .hash                   0 : {*(.hash)}
    .gnu.hash               0 : {*(.gnu.hash)}
    .dynsym                 0 : {*(.dynsym)}
    .dynstr                 0 : {*(.dynstr)}
    .gnu.version            0 : {*(.gnu.version)}
    .gnu.version_d          0 : {*(.gnu.version_d)}
    .gnu.version_r          0 : {*(.gnu.version_r)}
    .rel.init               0 : {*(.rel.init)}
    .rela.init              0 : {*(.rela.init)}
    .rel.text               0 : {*(.rel.text)}
    .rela.text              0 : {*(.rela.text)}
    .rel.fini               0 : {*(.rel.fini)}
    .rela.fini              0 : {*(.rela.fini)}
    .rel.rodata             0 : {*(.rel.rodata)}
    .rela.rodata            0 : {*(.rela.rodata)}
    .rel.data.rel.ro        0 : {*(.rel.data.rel.ro)}
    .rela.data.rel.ro       0 : {*(.rela.data.rel.ro)}
    .rel.data               0 : {*(.rel.data)}
    .rela.data              0 : {*(.rela.data)}
    .rel.tdata              0 : {*(.rel.tdata)}
    .rela.tdata             0 : {*(.rela.tdata)}
    .rel.tbss               0 : {*(.rel.tbss)}
    .rela.tbss              0 : {*(.rela.tbss)}
    .rel.ctors              0 : {*(.rel.ctors)}
    .rela.ctors             0 : {*(.rela.ctors)}
    .rel.dtors              0 : {*(.rel.dtors)}
    .rela.dtors             0 : {*(.rela.dtors)}
    .rel.got                0 : {*(.rel.got)}
    .rela.got               0 : {*(.rela.got)}
    .rel.dyn                0 : {*(.rel.dyn)}
    .rel.sdata              0 : {*(.rel.sdata)}
    .rela.sdata             0 : {*(.rela.sdata)}
    .rel.sbss               0 : {*(.rel.sbss)}
    .rela.sbss              0 : {*(.rela.sbss)}
    .rel.sdata2             0 : {*(.rel.sdata2)}
    .rela.sdata2            0 : {*(.rela.sdata2)}
    .rel.sbss2              0 : {*(.rel.sbss2)}
    .rela.sbss2             0 : {*(.rela.sbss2)}
    .rel.bss                0 : {*(.rel.bss)}
    .rela.bss               0 : {*(.rela.bss)}
    .rel.iplt               0 : {*(.rel.iplt)}
    .rela.iplt              0 : {*(.rela.iplt)}
    .rel.plt                0 : {*(.rel.plt)}
    .rela.plt               0 : {*(.rela.plt)}
    .init                   0 : {KEEP(*(SORT_NONE(.init)))}
    .text                   0 : {*(.text .stub) *(.gnu.warning)}
    .fini                   0 : {KEEP(*(SORT_NONE(.fini)))}
    .rodata                 0 : {*(.rodata)}
    .rodata1                0 : {*(.rodata1)}
    .sdata2                 0 : {*(.sdata2)}
    .sbss2                  0 : {*(.sbss2)}
    .eh_frame_hdr           0 : {*(.eh_frame_hdr)}
    .eh_frame               0 : ONLY_IF_RO {KEEP(*(.eh_frame))}
    .gcc_except_table       0 : ONLY_IF_RO {*(.gcc_except_table)}
    .gnu_extab              0 : ONLY_IF_RO {*(.gnu_extab*)}
    .exception_ranges       0 : ONLY_IF_RO {*(.exception_ranges)}
    .plt                    0 : {*(.plt)}
    .iplt                   0 : {*(.iplt)}
    .eh_frame               0 : ONLY_IF_RW {KEEP(*(.eh_frame))}
    .gnu_extab              0 : ONLY_IF_RW {*(.gnu_extab)}
    .gcc_except_table       0 : ONLY_IF_RW {*(.gcc_except_table)}
    .exception_ranges       0 : ONLY_IF_RW {*(.exception_ranges)}
    .tdata                  0 : {*(.tdata)}
    .tbss                   0 : {*(.tbss)}
    .jcr                    0 : {KEEP(*(.jcr))}
    .got.plt                0 : {*(.got.plt)}
    .data                   0 : {*(.data)}
    .data1                  0 : {*(.data1)}
    .got                    0 : {*(.got)}
    .sdata                  0 : {*(.sdata)}
    .lit8                   0 : {*(.lit8)}
    .lit4                   0 : {*(.lit4)}
    .sbss                   0 : {*(.sbss)}
    .bss                    0 : {*(.bss)}
    .stab                   0 : {*(.stab)}
    .stabstr                0 : {*(.stabstr)}
    .stab.excl              0 : {*(.stab.excl)}
    .stab.exclstr           0 : {*(.stab.exclstr)}
    .stab.index             0 : {*(.stab.index)}
    .stab.indexstr          0 : {*(.stab.indexstr)}
    .comment                0 : {*(.comment)}
    .gnu.build.attributes     : {*(.gnu.build.attributes)}
    .debug                  0 : {*(.debug)}
    .line                   0 : {*(.line)}
    .debug_srcinfo          0 : {*(.debug_srcinfo)}
    .debug_sfnames          0 : {*(.debug_sfnames)}
    .debug_aranges          0 : {*(.debug_aranges)}
    .debug_pubnames         0 : {*(.debug_pubnames)}
    .debug_info             0 : {*(.debug_info)}
    .debug_abbrev           0 : {*(.debug_abbrev)}
    .debug_line             0 : {*(.debug_line)}
    .debug_frame            0 : {*(.debug_frame)}
    .debug_str              0 : {*(.debug_str)}
    .debug_loc              0 : {*(.debug_loc)}
    .debug_macinfo          0 : {*(.debug_macinfo)}
    .debug_weaknames        0 : {*(.debug_weaknames)}
    .debug_funcnames        0 : {*(.debug_funcnames)}
    .debug_typenames        0 : {*(.debug_typenames)}
    .debug_varnames         0 : {*(.debug_varnames)}
    .debug_pubtypes         0 : {*(.debug_pubtypes)}
    .debug_ranges           0 : {*(.debug_ranges)}
    .debug_macro            0 : {*(.debug_macro)}
    .debug_addr             0 : {*(.debug_addr)}
    .gnu.attributes         0 : {KEEP(*(.gnu.attributes))}
    .gptab.sdata              : {*(.gptab.sdata)}
    .gptab.sbss               : {*(.gptab.sbss)}
    .mdebug.abi32           0 : {KEEP(*(.mdebug.abi32))}
    .mdebug.abiN32          0 : {KEEP(*(.mdebug.abiN32))}
    .mdebug.abi64           0 : {KEEP(*(.mdebug.abi64))}
    .mdebug.abiO64          0 : {KEEP(*(.mdebug.abiO64))}
    .mdebug.eabi32          0 : {KEEP(*(.mdebug.eabi32))}
    .mdebug.eabi64          0 : {KEEP(*(.mdebug.eabi64))}
    .gcc_compiled_long32    0 : {KEEP(*(.gcc_compiled_long32))}
    .gcc_compiled_long64    0 : {KEEP(*(.gcc_compiled_long64))}
    /DISCARD/                 : {*(.gptab.data); *(.gptab.bss)}
}
