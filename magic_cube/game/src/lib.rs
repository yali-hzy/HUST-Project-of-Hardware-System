#![no_std]

use render::draw_chess;
use render::W;
// use render::A;
// use render::S;
// use render::D;

mod render;


const WIDTH: usize = 488;
const HEIGHT: usize = 280;
pub trait Painter {
    fn draw(&mut self, x: usize, y: usize);
    fn set_color(&mut self, color: u8);
}

static mut POS: (usize, usize) = (0, 0);

pub fn init(painter: &mut impl Painter) {
    painter.set_color(1);
    for x in 0..WIDTH {
        painter.draw(x, 0);
        painter.draw(x, HEIGHT >> 1);
        painter.draw(x, HEIGHT - 1);
    }
    for y in 0..HEIGHT {
        painter.draw(0, y);
        painter.draw(WIDTH >> 1, y);
        painter.draw(WIDTH - 1, y);
    }
    draw_chess(painter);
}

#[allow(dead_code)]
pub fn handle_up(painter: &mut impl Painter) {
    unsafe {
        POS.1 = POS.1.saturating_sub(1);
        painter.draw(POS.0, POS.1);
        painter.draw(POS.0, POS.1 + 1);
        painter.draw(POS.0 + 1, POS.1);
        painter.draw(POS.0 + 1, POS.1 + 1);
    }
    W(painter);
}

#[allow(dead_code)]
pub fn handle_down(painter: &mut impl Painter) {
    unsafe {
        POS.1 = POS.1.unchecked_add(1);
        painter.draw(POS.0, POS.1);
        painter.draw(POS.0, POS.1 + 1);
        painter.draw(POS.0 + 1, POS.1);
        painter.draw(POS.0 + 1, POS.1 + 1);
    }
    //S(painter);
}

#[allow(dead_code)]
pub fn handle_left(painter: &mut impl Painter) {
    unsafe {
        POS.0 = POS.0.saturating_sub(1);
        painter.draw(POS.0, POS.1);
        painter.draw(POS.0, POS.1 + 1);
        painter.draw(POS.0 + 1, POS.1);
        painter.draw(POS.0 + 1, POS.1 + 1);
    }
    //A(painter);
}

#[allow(dead_code)]
pub fn handle_right(painter: &mut impl Painter) {
    unsafe {
        POS.0 = POS.0.saturating_add(1);
        painter.draw(POS.0, POS.1);
        painter.draw(POS.0, POS.1 + 1);
        painter.draw(POS.0 + 1, POS.1);
        painter.draw(POS.0 + 1, POS.1 + 1);
    }
    //D(painter);
}
