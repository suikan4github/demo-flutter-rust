
# CHANGELOG

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).



## [Unreleased]

## [v0.1.9] - 2025-07-01

### Changed
- Release artifact filenames now follow the format `${project_name}-${version}-${target_os}-${arch}.${extension}` (e.g., `demo-flutter-rust-cpu-0.1.9-linux-x86_64.tar.gz`).
- The `${arch}` part is normalized to `x86_64` or `aarch64` depending on the build environment.
- This change applies to all platforms: Linux, Windows, and macOS.

## [v0.1.8] - 2025-07-01

### Changed
- Unified the placement of Rust FFI libraries (`libcpu_monitor.so`, `cpu_monitor.dll`, `libcpu_monitor.dylib`) under the `lib/` subdirectory for all platforms.
- Updated Dart FFI loading paths to use the `lib/` subdirectory for all platforms.
- Modified CI/CD workflow (`build.yml`) to copy the Rust library into the `lib/` subdirectory inside each platform's Flutter bundle.
- Ensured that the FFI library is always found at runtime for all distributed binaries (Linux, Windows, macOS).

### Fixed
- Fixed an issue where the Rust FFI library was missing from the distributed zip/tar.gz, causing the app to fail to start.

## [v0.1.7] - 2025-07-01

### Fixed
- Bundled Rust FFI library (`libcpu_monitor.so`, `cpu_monitor.dll`, `libcpu_monitor.dylib`) is now included in the distributed zip/tar.gz for all platforms (Linux, Windows, macOS).
- Fixed runtime error where the app could not find the Rust dynamic library after extracting the artifact.

### Changed
- CI/CD workflow now copies the Rust library to the Flutter build output directory for each platform before packaging artifacts.

## [v0.1.6] - 2025-07-01

### Fixed
- Fixed permission issue in GitHub Actions workflows
- Added explicit permissions for `contents: write` in `build.yml`.

## [v0.1.5] - 2025-06-30

### Fixed
- Fixed cargo fmt formatting error in Rust CI/CD workflow
- Automatically formatted Rust code (cpu_monitor/src/lib.rs) with cargo fmt
- Fixed PowerShell mkdir error in Windows build workflow (now succeeds even if directory exists)

### Changed
- Improved stability of CI/CD workflows (build.yml, ci.yml, etc.)

## [v0.1.3] - 2025-06-30

### Fixed
- Update CI/CD workflows to use Flutter 3.32.5 for Dart 3.8+ compatibility
- Resolve CI failure due to Dart SDK version mismatch

### Changed
- All workflow files now explicitly specify Flutter 3.32.5

## [v0.1.2] - 2025-06-30

### Fixed
- Rust clippy warnings and compilation errors
- Removed unused import (`Cpu` from sysinfo)
- Fixed unsafe block usage in test functions
- Corrected static mutable reference patterns using raw pointers
- Marked `free_string` function as properly unsafe
- Replaced manual range check with `contains()` method
- Updated Flutter version in CI to 3.24.5 for better stability

### Changed
- Improved memory safety in Rust library tests
- Enhanced CI/CD pipeline reliability

## [v0.1.1] - 2025-06-30

### Added
- CI/CD pipeline with GitHub Actions
- Comprehensive testing (Flutter widget tests + Rust unit tests)
- Multi-platform build support (Linux, Windows, macOS)
- Dynamic grid layout for CPU display (1-3 columns based on CPU count)
- Responsive UI design with fixed card height and adaptive width

### Changed
- Improved CPU usage bar layout (removed redundant labels)
- Enhanced UI responsiveness for different window sizes
- Updated project structure (flattened directory hierarchy)
- Modernized README with CI/CD documentation

### Fixed
- Code formatting issues in Dart and Rust code
- UI layout improvements for better visual consistency

## [v0.1.0] - 2025-06-30

### Added
- Initial Flutter-Rust CPU Monitor Demo application
- Real-time CPU usage monitoring with Rust backend
- Flutter UI with Material Design 3
- FFI (Foreign Function Interface) integration between Dart and Rust
- Cross-platform support (Linux, Windows, macOS, Web)
- CPU usage visualization with progress bars
- Multi-core CPU support with individual core monitoring
- Rust library (`cpu_monitor`) using sysinfo crate
- Dart bindings for Rust library integration
- Error handling for FFI initialization and operations

### Technical Details
- Rust library built as C dynamic library (cdylib)
- sysinfo crate for cross-platform system monitoring
- Flutter Material 3 design system
- Real-time updates every 500ms
- Memory-safe Rust implementation with proper string handling
- Platform-specific library loading (Linux: .so, Windows: .dll, macOS: .dylib)
- 
[Unreleased]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.9...develop
[v0.1.9]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.8...v0.1.9
[v0.1.8]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.7...v0.1.8
[v0.1.7]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.6...v0.1.7
[v0.1.6]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.5...v0.1.6
[v0.1.5]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.3...v0.1.5
[v0.1.3]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/suikan4github/demo-flutter-rust-cpu/releases/tag/v0.1.0
