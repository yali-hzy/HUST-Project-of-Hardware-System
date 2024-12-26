# Building
TARGET := riscv32i-unknown-none-elf
MODE := debug
KERNEL_ELF := target/$(TARGET)/$(MODE)/bare_metal
KERNEL_BIN := $(KERNEL_ELF).bin
DUMP := main.dump

# Building mode argument
ifeq ($(MODE), release)
	MODE_ARG := --release
endif

# Binutils
OBJDUMP := rust-objdump --arch-name=riscv32i
OBJCOPY := rust-objcopy --binary-architecture=riscv32i

$(KERNEL_BIN):
	@$(OBJCOPY) $(KERNEL_ELF) --strip-all -O binary $@

bare-metal:
	@cargo build $(MODE_ARG) --target $(TARGET) --bin bare_metal

bare-metal-objdump:
	@cargo objdump $(MODE_ARG) --target $(TARGET) --bin bare_metal -- --disassemble --print-imm-hex > $(DUMP)

QEMU_ARGS := -machine virt \
			 -nographic \
			 -kernel $(KERNEL_ELF)

debug:
	@tmux new-session -d \
		"qemu-system-riscv32 $(QEMU_ARGS) -s -S" && \
		tmux split-window -h "riscv64-elf-gdb -ex 'file $(KERNEL_ELF)' -ex 'set arch riscv:rv32' -ex 'target remote localhost:1234'" && \
		tmux -2 attach-session -d

gdbserver:
	@qemu-system-riscv32 $(QEMU_ARGS) -s -S

gdbclient:
	@riscv64-elf-gdb -ex 'file $(KERNEL_ELF)' -ex 'set arch riscv:rv32' -ex 'target remote localhost:1234'

.PHONY: gdbserver gdbclient debug bare-metal bare-metal-objdump
