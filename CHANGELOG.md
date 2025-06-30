# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.3...develop
[v0.1.3]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/suikan4github/demo-flutter-rust-cpu/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/suikan4github/demo-flutter-rust-cpu/releases/tag/v0.1.0
