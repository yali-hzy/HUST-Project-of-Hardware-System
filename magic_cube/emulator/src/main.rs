extern crate sdl2;

use game::{handle_down, handle_left, handle_right, handle_up, Painter};
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::pixels::PixelFormatEnum;
use sdl2::rect::Rect;
use std::io::{stdout, Write};
use std::time::Duration;

const WIDTH: u32 = 488;
const HEIGHT: u32 = 280;

struct SDL2Painter<'a> {
    texture: sdl2::render::Texture<'a>,
    pixel_color_data: [u8; 2],
}

impl<'a> Painter for SDL2Painter<'a> {
    fn draw(&mut self, x: usize, y: usize) {
        assert!((x < (WIDTH) as usize));
        assert!((y < (HEIGHT) as usize));
        self.texture
            .update(
                Rect::new(x as i32, y as i32, 1, 1),
                &self.pixel_color_data,
                2,
            )
            .unwrap();
    }

    fn set_color(&mut self, color: u8) {
        let (r, g, b) = match color {
            0 => (240, 240, 240),
            1 => (255, 204, 204),
            2 => (204, 255, 204),
            3 => (204, 204, 255),
            4 => (255, 255, 204),
            5 => (100, 204, 255),
            6 => (204, 255, 255),
            7 => (255, 255, 255),
            8 => (192, 192, 192),
            9 => (192, 128, 128),
            10 => (128, 192, 128),
            11 => (128, 128, 192),
            _ => panic!("Invalid color"),
        };
        let r = r >> 4;
        let g = g >> 4;
        let b = b >> 4;
        self.pixel_color_data[0] = (g << 4) | (b);
        self.pixel_color_data[1] = (0xf << 4) | (r);
    }
    fn print(&self, args: std::fmt::Arguments) {
        stdout().write_fmt(args).unwrap();
    }
}

pub fn main() {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();

    // 创建窗口
    let window = video_subsystem
        .window("Rust SDL2 Pixel Drawing", WIDTH, HEIGHT)
        .position_centered()
        .opengl()
        .build()
        .map_err(|e| e.to_string())
        .unwrap();

    let mut canvas = window
        .into_canvas()
        .present_vsync()
        .build()
        .map_err(|e| e.to_string())
        .unwrap();

    // 创建一个纹理
    let texture_creator = canvas.texture_creator();
    let texture = texture_creator
        .create_texture_streaming(PixelFormatEnum::ARGB4444, WIDTH, HEIGHT)
        .map_err(|e| e.to_string())
        .unwrap();

    let mut painter = SDL2Painter {
        texture,
        pixel_color_data: [0, 0],
    };

    game::init(&mut painter);

    let mut event_pump = sdl_context.event_pump().unwrap();
    'running: loop {
        for event in event_pump.poll_iter() {
            match event {
                Event::KeyDown { keycode, .. } => match keycode {
                    Some(Keycode::W) => {
                        println!("W");
                        handle_up(&mut painter);
                    }
                    Some(Keycode::A) => {
                        println!("A");
                        handle_left(&mut painter);
                    }
                    Some(Keycode::S) => {
                        println!("S");
                        handle_down(&mut painter);
                    }
                    Some(Keycode::D) => {
                        println!("D");
                        handle_right(&mut painter);
                    }
                    _ => {}
                },
                Event::Quit { .. } => break 'running,
                _ => {}
            }
        }
        // The rest of the game loop goes here...
        canvas.clear();
        canvas.copy(&painter.texture, None, None).unwrap();
        canvas.present();
        ::std::thread::sleep(Duration::new(0, 1_000_000_000u32 / 60));
    }
}
