use std::ffi::CString;
use std::os::raw::{c_char, c_int};
use sysinfo::{Cpu, System};

static mut SYSTEM: Option<System> = None;

#[no_mangle]
pub extern "C" fn init_cpu_monitor() {
    unsafe {
        SYSTEM = Some(System::new_all());
    }
}

#[no_mangle]
pub extern "C" fn get_cpu_count() -> c_int {
    unsafe {
        if let Some(system) = &SYSTEM {
            system.cpus().len() as c_int
        } else {
            0
        }
    }
}

#[no_mangle]
pub extern "C" fn update_cpu_info() {
    unsafe {
        if let Some(system) = &mut SYSTEM {
            system.refresh_cpu_all();
        }
    }
}

#[no_mangle]
pub extern "C" fn get_cpu_usage(cpu_index: c_int) -> f32 {
    unsafe {
        if let Some(system) = &SYSTEM {
            if let Some(cpu) = system.cpus().get(cpu_index as usize) {
                cpu.cpu_usage()
            } else {
                0.0
            }
        } else {
            0.0
        }
    }
}

#[no_mangle]
pub extern "C" fn get_cpu_name(cpu_index: c_int) -> *mut c_char {
    unsafe {
        if let Some(system) = &SYSTEM {
            if let Some(cpu) = system.cpus().get(cpu_index as usize) {
                let name = cpu.name();
                if let Ok(c_string) = CString::new(name) {
                    return c_string.into_raw();
                }
            }
        }
        std::ptr::null_mut()
    }
}

#[no_mangle]
pub extern "C" fn free_string(s: *mut c_char) {
    unsafe {
        if !s.is_null() {
            let _ = CString::from_raw(s);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_cpu_monitor_initialization() {
        unsafe {
            init_cpu_monitor();
            assert!(SYSTEM.is_some());
        }
    }

    #[test]
    fn test_get_cpu_count() {
        unsafe {
            init_cpu_monitor();
            let count = get_cpu_count();
            assert!(count > 0, "CPU count should be greater than 0");
        }
    }

    #[test]
    fn test_cpu_usage_range() {
        unsafe {
            init_cpu_monitor();
            update_cpu_info();

            let cpu_count = get_cpu_count();
            for i in 0..cpu_count {
                let usage = get_cpu_usage(i);
                assert!(
                    usage >= 0.0 && usage <= 100.0,
                    "CPU usage should be between 0.0 and 100.0, got {}",
                    usage
                );
            }
        }
    }

    #[test]
    fn test_cpu_name_not_null() {
        unsafe {
            init_cpu_monitor();
            let cpu_count = get_cpu_count();

            if cpu_count > 0 {
                let name_ptr = get_cpu_name(0);
                assert!(!name_ptr.is_null(), "CPU name should not be null");

                // Free the string to avoid memory leak in test
                free_string(name_ptr);
            }
        }
    }

    #[test]
    fn test_invalid_cpu_index() {
        unsafe {
            init_cpu_monitor();
            let cpu_count = get_cpu_count();

            // Test with invalid index
            let usage = get_cpu_usage(cpu_count + 10);
            assert_eq!(usage, 0.0, "Invalid CPU index should return 0.0");

            let name_ptr = get_cpu_name(cpu_count + 10);
            assert!(
                name_ptr.is_null(),
                "Invalid CPU index should return null pointer"
            );
        }
    }
}
