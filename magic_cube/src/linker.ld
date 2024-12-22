OUTPUT_ARCH(riscv32i)
ENTRY(_start)
BASE_ADDRESS = 0x0;
TRAP_ADDRESS = 0x30;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : {
        *(.text.entry)
        . = TRAP_ADDRESS;
        *(.text.trampoline)
        *(.text .text.*)
    }
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }
    .data : {
        *(.data .data.*)
        *(.sdata .sdata.*)
    }
    .bss : {
        *(.bss.stack)
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    /DISCARD/ : {
        *(.eh_frame)
    }
}