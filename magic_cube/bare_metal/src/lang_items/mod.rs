use crate::console::print;

#[panic_handler]
fn panic(info: &core::panic::PanicInfo) -> ! {
    let x = info
        .location()
        .map(|loc| (loc.line() << 8) | (loc.column()))
        .unwrap_or(0xdeadbeef);
    loop {
        print(x as usize);
    }
}
