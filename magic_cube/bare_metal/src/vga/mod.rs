pub const VGA_WIDTH: usize = 488;
pub const _VGA_HEIGHT: usize = 280;

pub struct Vga {}

pub static VGA: Vga = Vga {};

impl Vga {
    pub fn get_frame_buffer(&self) -> *mut u8 {
        extern "C" {
            fn video_memory_start();
        }
        video_memory_start as *mut u8
    }

    pub fn draw_pixel(&self, x: usize, y: usize, color: u8) {
        assert!(x < VGA_WIDTH);
        assert!(y < _VGA_HEIGHT);

        let frame_buffer = self.get_frame_buffer();
        let offset = x + y * VGA_WIDTH;
        let bit = offset & 1;
        let old_color = unsafe { frame_buffer.add(offset >> 1).read_volatile() };
        let color = if bit == 0 {
            (old_color & 0xf0) | color
        } else {
            (old_color & 0x0f) | (color << 4)
        };
        unsafe {
            frame_buffer.add(offset >> 1).write_volatile(color);
        }
    }
}
