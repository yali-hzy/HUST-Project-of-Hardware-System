use std::path::PathBuf;

use lazy_static::lazy_static;

lazy_static! {
    static ref TARGET_PATH: String = {
        let mut path = PathBuf::from(std::env::var("OUT_DIR").unwrap());
        path.pop();
        path.pop();
        path.pop();
        String::from(path.to_str().unwrap())
    };
}
static CARGO_MANIFEST_DIR: &str = env!("CARGO_MANIFEST_DIR");

fn main() {
    println!(
        "cargo:rustc-link-arg=-T{}/src/linker.ld",
        CARGO_MANIFEST_DIR
    );
}
