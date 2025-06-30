# Flutter-Rust CPU Monitor Demo

A demonstration application showcasing the collaboration between Flutter and Rust to display real-time CPU usage information.

## Overview

This project demonstrates how to integrate Rust code with Flutter applications to create efficient, cross-platform mobile apps with native performance. The application displays real-time CPU usage statistics by leveraging Rust's performance capabilities for system monitoring while maintaining Flutter's excellent UI framework.

## Features

- Real-time CPU usage monitoring
- Cross-platform compatibility (Android, iOS, Linux, macOS, Windows, Web)
- Native performance through Rust backend
- Modern Flutter UI

## Architecture

- **Frontend**: Flutter application with Dart
- **Backend**: Rust library (`cpu_monitor`) for system monitoring
- **Bridge**: Dart-Rust FFI bindings for seamless integration

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Rust toolchain
- Platform-specific development tools (Android Studio, Xcode, etc.)

### Building and Running

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Build the Rust library:
   ```bash
   cd cpu_monitor
   cargo build --release
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/` - Flutter application code
- `cpu_monitor/` - Rust library for CPU monitoring
- `lib/cpu_monitor_bindings.dart` - Dart FFI bindings
- Platform-specific directories (`android/`, `ios/`, `linux/`, etc.)

## Learn More

This project serves as a practical example of:
- Flutter-Rust integration using FFI
- Cross-platform native library development
- Real-time system monitoring in mobile applications
