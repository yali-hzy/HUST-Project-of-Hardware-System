#![no_std]

use render::draw_chess;
// use render::W;
// use render::A;
// use render::S;
// use render::D;

mod render;
mod sync;

#[allow(dead_code)]
const WIDTH: usize = 488;
#[allow(dead_code)]
const HEIGHT: usize = 280;

pub trait Painter {
    fn draw(&mut self, x: usize, y: usize);
    fn set_color(&mut self, color: u8);
}

static _POS: sync::UPSafeCell<(usize, usize)> = sync::UPSafeCell::new((0, 0));

pub fn init(painter: &mut impl Painter) {
    draw_chess(painter);
}

#[allow(dead_code)]
pub fn handle_up(painter: &mut impl Painter) {}

#[allow(dead_code)]
pub fn handle_down(painter: &mut impl Painter) {}

#[allow(dead_code)]
pub fn handle_left(painter: &mut impl Painter) {}

#[allow(dead_code)]
pub fn handle_right(painter: &mut impl Painter) {}
