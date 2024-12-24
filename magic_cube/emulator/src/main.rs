extern crate sdl2;

use game::{handle_down, handle_left, handle_right, handle_up, Painter};
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::pixels::PixelFormatEnum;
use sdl2::rect::Rect;
use std::time::Duration;

const WIDTH: u32 = 640;
const HEIGHT: u32 = 480;

struct SDL2Painter<'a> {
    texture: sdl2::render::Texture<'a>,
    r: u8,
    g: u8,
    b: u8,
}

impl<'a> Painter for SDL2Painter<'a> {
    fn draw(&mut self, x: usize, y: usize) {
        self.texture
            .update(
                Rect::new(x as i32, y as i32, 1, 1),
                &[self.b, self.g, self.r, 255],
                4,
            )
            .unwrap();
        println!(
            "draw: {}, {}, r: {}, g: {}, b: {}",
            x, y, self.r, self.g, self.b
        );
    }

    fn set_color(&mut self, color: u8) {
        let (r, g, b) = match color {
            0 => (0, 0, 0),
            1 => (255, 0, 0),
            2 => (0, 255, 0),
            3 => (0, 0, 255),
            4 => (255, 255, 0),
            5 => (255, 0, 255),
            6 => (0, 255, 255),
            7 => (255, 255, 255),
            _ => panic!("Invalid color"),
        };
        self.r = r;
        self.g = g;
        self.b = b;
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
    let mut texture = texture_creator
        .create_texture_streaming(PixelFormatEnum::ARGB8888, WIDTH, HEIGHT)
        .map_err(|e| e.to_string())
        .unwrap();

    let mut painter = SDL2Painter {
        texture,
        r: 0,
        g: 0,
        b: 0,
    };

    painter.set_color(1);

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
