#![no_std]
#![no_main]

mod console;
mod lang_items;
mod trap;
mod vga;

use console::print;
use core::arch::global_asm;
use vga::{VGA, VGA_WIDTH, _VGA_HEIGHT};

global_asm!(include_str!("entry.asm"));

#[no_mangle]
fn rust_main() {
    trap::init();
    let mut counter = 0usize;
    loop {
        counter += 1;
        print(counter);
        draw_test();
    }
}

fn draw_test() {
    let mut c = 0;
    for x in 0..VGA_WIDTH {
        for y in 0.._VGA_HEIGHT {
            VGA.draw_pixel(x, y, c);
            c += 1;
        }
    }
}
