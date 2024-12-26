/// print string macro
#[macro_export]
macro_rules! print {
    ($painter: expr, $fmt: literal $(, $($arg: tt)+)?) => {
        $painter.print(format_args!($fmt $(, $($arg)+)?));
    }
}

/// println string macro
#[macro_export]
macro_rules! println {
    ($painter: expr, $fmt: literal $(, $($arg: tt)+)?) => {
        $painter.print(format_args!(concat!($fmt, "\n") $(, $($arg)+)?));
    }
}
