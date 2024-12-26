//! Trap handling functionality
//!
//! For rCore, we have a single trap entry point, namely `__alltraps`. At
//! initialization in [`init()`], we set the `stvec` CSR to point to it.
//!
//! All traps go through `__alltraps`, which is defined in `trap.S`. The
//! assembly language code does just enough work restore the kernel space
//! context, ensuring that Rust code safely runs, and transfers control to
//! [`trap_handler()`].
//!
//! It then calls different functionality based on what exactly the exception
//! was. For example, timer interrupts trigger task preemption, and syscalls go
//! to [`syscall()`].

use core::arch::global_asm;

use game::{handle_down, handle_left, handle_right, handle_up};
use riscv::register::mcause;

use crate::{
    console::{pause, print},
    vga::get_vga,
};

global_asm!(include_str!("trap.s"));

extern "C" {
    pub fn __alltraps();
    pub fn __restore() -> !;
}

/// Make rustc happy (reserve .text.trampoline section)
pub fn init() {
    print(__alltraps as usize);
    pause();
}

/// handle an interrupt, exception, or system call from user space
#[no_mangle]
pub fn trap_handler() {
    let mcause = mcause::read().bits();
    match mcause {
        0..=3 => {
            handle_input(mcause);
        }
        _ => {
            print(mcause << 16 | 0xdead);
            pause();
        }
    }
}

fn handle_input(mcause: usize) {
    match mcause {
        0 => {
            handle_up(get_vga());
        }
        1 => {
            handle_left(get_vga());
        }
        2 => {
            handle_right(get_vga());
        }
        3 => {
            handle_down(get_vga());
        }
        _ => {
            panic!()
        }
    }
}
