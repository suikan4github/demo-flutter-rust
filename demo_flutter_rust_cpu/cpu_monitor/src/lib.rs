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
