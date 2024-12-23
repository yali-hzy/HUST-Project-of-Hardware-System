use crate::console::{pause, print};

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {
        print(0xFFFFFFFF);
        pause();
    }
}
