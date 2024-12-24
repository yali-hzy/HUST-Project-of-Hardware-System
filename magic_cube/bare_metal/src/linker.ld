OUTPUT_ARCH(riscv32i)
ENTRY(_start)
BASE_ADDRESS = 0x0;
TRAP_ADDRESS = 0x30;
VGA_BASE = 0x20000;
DATA_BASE = 0x30AE0;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : {
        *(.text.entry)
        . = TRAP_ADDRESS;
        *(.text.trampoline)
        *(.text .text.*)
    }
    . = VGA_BASE;
    video_memory_start = .;
    . = DATA_BASE;
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