#![no_std]
#![no_main]

mod console;
mod game;
mod lang_items;
mod trap;
mod vga;

use core::arch::{asm, global_asm};
use vga::VGA;

global_asm!(include_str!("entry.asm"));

#[no_mangle]
fn rust_main() {
    trap::init();
    unsafe {
        loop {
            draw_test();
            asm!("nop");
        }
    }
}

fn draw_test() {
    VGA.draw_pixel(0, 0, 0);
}
