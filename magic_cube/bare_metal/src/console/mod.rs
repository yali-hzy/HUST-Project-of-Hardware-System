use core::arch::asm;

#[cfg(not(feature = "disable_ecall"))]
use riscv::asm::ecall;

pub fn print(word: usize) {
    unsafe {
        // Write a7 = 34
        asm!("li a7, 34");
        // Write a0 = word
        asm!("mv a0, {}", in(reg) word);
        #[cfg(not(feature = "disable_ecall"))]
        ecall();
    }
}

pub fn pause() {
    unsafe {
        // Write a7 = 93
        asm!("li a7, 93");
        #[cfg(not(feature = "disable_ecall"))]
        ecall();
    }
}
