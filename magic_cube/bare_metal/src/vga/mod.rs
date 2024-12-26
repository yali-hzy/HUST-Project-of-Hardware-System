use game::Painter;

use crate::console::{pause, print};

pub const VGA_WIDTH: usize = 488;
pub const VGA_HEIGHT: usize = 280;

pub struct Vga {
    color: u8,
}

static mut VGA: Vga = Vga { color: 0x0F };

impl Vga {
    pub fn get_frame_buffer(&self) -> *mut u8 {
        extern "C" {
            fn video_memory_start();
        }
        video_memory_start as *mut u8
    }

    pub fn draw_pixel(&self, x: usize, y: usize, color: u8) {
        assert!(x < VGA_WIDTH);
        assert!(y < VGA_HEIGHT);

        let frame_buffer = self.get_frame_buffer();
        let offset = x + y * VGA_WIDTH;
        let bit = offset & 1;
        let old_color = unsafe { frame_buffer.add(offset >> 1).read_volatile() };
        let new_color = if bit == 0 {
            (old_color & 0xf0) | color
        } else {
            (old_color & 0x0f) | (color << 4)
        };
        unsafe {
            frame_buffer.add(offset >> 1).write_volatile(new_color);
        }
    }
}

impl Painter for Vga {
    fn draw(&mut self, x: usize, y: usize) {
        self.draw_pixel(x, y, self.color);
    }

    fn set_color(&mut self, color: u8) {
        self.color = color;
    }
}

pub fn init() {
    print(get_vga().get_frame_buffer() as usize);
    pause();
}

pub fn get_vga() -> &'static mut Vga {
    unsafe { (&raw mut VGA).as_mut().unwrap() }
}
