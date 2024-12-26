#![no_std]
#![no_main]

mod console;
mod lang_items;
mod trap;
mod vga;

use core::arch::global_asm;
use vga::get_vga;

global_asm!(include_str!("entry.asm"));

#[no_mangle]
fn rust_main() {
    trap::init();
    vga::init();
    game::init(get_vga());
    loop {}
}
