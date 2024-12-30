/// print string macro
#[macro_export]
macro_rules! print {
    ($painter: expr, $fmt: literal $(, $($arg: tt)+)?) => {
        #[cfg(not(target_os = "none"))]
        $painter.print(format_args!($fmt $(, $($arg)+)?));
    }
}

/// println string macro
#[macro_export]
macro_rules! println {
    ($painter: expr, $fmt: literal $(, $($arg: tt)+)?) => {
        #[cfg(not(target_os = "none"))]
        $painter.print(format_args!(concat!($fmt, "\n") $(, $($arg)+)?));
    }
}
