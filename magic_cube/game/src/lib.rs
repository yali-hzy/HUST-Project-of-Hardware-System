pub trait Painter {
    fn draw(&mut self, x: usize, y: usize);
    fn set_color(&mut self, color: u8);
}

#[allow(dead_code)]
pub fn handle_up(painter: &mut impl Painter) {
    let _ = painter;
}

#[allow(dead_code)]
pub fn handle_down(painter: &mut impl Painter) {
    let _ = painter;
}

#[allow(dead_code)]
pub fn handle_left(painter: &mut impl Painter) {
    let _ = painter;
}

#[allow(dead_code)]
pub fn handle_right(painter: &mut impl Painter) {
    let _ = painter;
}
