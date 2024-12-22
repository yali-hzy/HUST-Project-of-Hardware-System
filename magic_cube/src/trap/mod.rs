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

use riscv::register::mcause;

use crate::{
    console::{pause, print},
    game::handle_input,
};

global_asm!(include_str!("trap.s"));

extern "C" {
    pub fn __alltraps();
    pub fn __restore() -> !;
}

/// Make rustc happy (reserve .text.trampoline section)
pub fn init() {
    print(__alltraps as usize);
}

/// handle an interrupt, exception, or system call from user space
#[no_mangle]
pub fn trap_handler() {
    let mcause = mcause::read().bits();
    match mcause {
        // 0..=3 => {
        //     handle_input(mcause);
        // }
        _ => {
            print(0xdeadbeef);
            pause();
        }
    }
}
