OUTPUT_ARCH(riscv32i)
ENTRY(_start)
BASE_ADDRESS = 0x80200000;
TRAP_ADDRESS = BASE_ADDRESS + 0x30;
VGA_BASE = BASE_ADDRESS + 0x40000;
DATA_BASE = BASE_ADDRESS + 0x50AE0;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : {
        *(.text.entry)
        . = TRAP_ADDRESS;
        *(.text.trap)
        *(.text .text.*)
    }
    . = VGA_BASE;
    video_memory_start = .;
    . = DATA_BASE;
    . = ALIGN(4);
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }
    . = ALIGN(4);
    .data : {
        *(.data .data.*)
        *(.sdata .sdata.*)
    }
    . = ALIGN(4);
    .bss : {
        *(.bss.stack)
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    /DISCARD/ : {
        *(.eh_frame)
    }
}