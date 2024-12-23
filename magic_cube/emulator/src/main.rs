extern crate sdl2;

use game::{handle_down, handle_left, handle_right, handle_up, Painter};
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::pixels::Color;
use sdl2::rect::Point;
use std::time::Duration;

struct SDL2Painter {
    canvas: sdl2::render::Canvas<sdl2::video::Window>,
}

impl Painter for SDL2Painter {
    fn draw(&mut self, x: usize, y: usize) {
        let _ = self.canvas.draw_point(Point::new(x as i32, y as i32));
        self.canvas.present();
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
            _ => (0, 0, 0),
        };
        self.canvas.set_draw_color(Color::RGB(r, g, b));
    }
}

pub fn main() {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();

    let window = video_subsystem
        .window("rust-sdl2 demo", 800, 600)
        .position_centered()
        .build()
        .unwrap();

    let canvas = window.into_canvas().build().unwrap();

    let mut painter = SDL2Painter { canvas };
    let mut event_pump = sdl_context.event_pump().unwrap();
    'running: loop {
        for event in event_pump.poll_iter() {
            match event {
                Event::KeyDown { keycode, .. } => match keycode {
                    Some(Keycode::W) => {
                        handle_up(&mut painter);
                    }
                    Some(Keycode::A) => {
                        handle_left(&mut painter);
                    }
                    Some(Keycode::S) => {
                        handle_down(&mut painter);
                    }
                    Some(Keycode::D) => {
                        handle_right(&mut painter);
                    }
                    _ => {}
                },
                Event::Quit { .. } => break 'running,
                _ => {}
            }
        }
        // The rest of the game loop goes here...
        ::std::thread::sleep(Duration::new(0, 1_000_000_000u32 / 60));
    }
}
