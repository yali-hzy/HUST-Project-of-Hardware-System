use core::cell::{RefCell, RefMut};

pub struct UPSafeCell<T> {
    /// inner data
    inner: RefCell<T>,
}

unsafe impl<T> Sync for UPSafeCell<T> {}

impl<T> UPSafeCell<T> {
    /// User is responsible to guarantee that inner struct is only used in
    /// uniprocessor.
    pub const fn new(value: T) -> Self {
        Self {
            inner: RefCell::new(value),
        }
    }
    /// Panic if the data has been borrowed.
    pub fn as_mut(&self) -> RefMut<'_, T> {
        self.inner.borrow_mut()
    }
}
