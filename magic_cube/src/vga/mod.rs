const VGA_WIDTH: usize = 320;
const _VGA_HEIGHT: usize = 200;

pub struct Vga {
    video_memory_start: usize,
}

pub static VGA: Vga = Vga {
    video_memory_start: 0xA0000,
};

impl Vga {
    pub fn get_frame_buffer(&self) -> *mut u8 {
        self.video_memory_start as *mut u8
    }

    pub fn draw_pixel(&self, x: usize, y: usize, color: u8) {
        assert!(x < VGA_WIDTH);
        assert!(y < _VGA_HEIGHT);

        let frame_buffer = self.get_frame_buffer();
        let offset = x + y * VGA_WIDTH;
        unsafe {
            frame_buffer.add(offset).write_volatile(color);
        }
    }
}
