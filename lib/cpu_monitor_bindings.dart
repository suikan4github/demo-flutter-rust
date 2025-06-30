import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Rust関数のバインディング
typedef InitCpuMonitorC = Void Function();
typedef InitCpuMonitor = void Function();

typedef GetCpuCountC = Int32 Function();
typedef GetCpuCount = int Function();

typedef UpdateCpuInfoC = Void Function();
typedef UpdateCpuInfo = void Function();

typedef GetCpuUsageC = Float Function(Int32);
typedef GetCpuUsage = double Function(int);

typedef GetCpuNameC = Pointer<Utf8> Function(Int32);
typedef GetCpuName = Pointer<Utf8> Function(int);

typedef FreeStringC = Void Function(Pointer<Utf8>);
typedef FreeString = void Function(Pointer<Utf8>);

class CpuMonitorBindings {
  late DynamicLibrary _dylib;
  late InitCpuMonitor _initCpuMonitor;
  late GetCpuCount _getCpuCount;
  late UpdateCpuInfo _updateCpuInfo;
  late GetCpuUsage _getCpuUsage;
  late GetCpuName _getCpuName;
  late FreeString _freeString;

  CpuMonitorBindings() {
    // ライブラリのパスを設定
    final libraryPath = _getLibraryPath();
    _dylib = DynamicLibrary.open(libraryPath);

    // 関数をバインド
    _initCpuMonitor = _dylib
        .lookup<NativeFunction<InitCpuMonitorC>>('init_cpu_monitor')
        .asFunction<InitCpuMonitor>();

    _getCpuCount = _dylib
        .lookup<NativeFunction<GetCpuCountC>>('get_cpu_count')
        .asFunction<GetCpuCount>();

    _updateCpuInfo = _dylib
        .lookup<NativeFunction<UpdateCpuInfoC>>('update_cpu_info')
        .asFunction<UpdateCpuInfo>();

    _getCpuUsage = _dylib
        .lookup<NativeFunction<GetCpuUsageC>>('get_cpu_usage')
        .asFunction<GetCpuUsage>();

    _getCpuName = _dylib
        .lookup<NativeFunction<GetCpuNameC>>('get_cpu_name')
        .asFunction<GetCpuName>();

    _freeString = _dylib
        .lookup<NativeFunction<FreeStringC>>('free_string')
        .asFunction<FreeString>();
  }

  String _getLibraryPath() {
    if (Platform.isLinux) {
      return 'cpu_monitor/target/release/libcpu_monitor.so';
    } else if (Platform.isMacOS) {
      return 'cpu_monitor/target/release/libcpu_monitor.dylib';
    } else if (Platform.isWindows) {
      // 複数の場所を試行
      final possiblePaths = [
        'cpu_monitor.dll', // 実行ファイルと同じディレクトリ
        'data\\cpu_monitor.dll', // dataディレクトリ
        'cpu_monitor\\target\\release\\cpu_monitor.dll', // 開発時のパス
      ];
      
      for (final dllPath in possiblePaths) {
        if (File(dllPath).existsSync()) {
          return dllPath;
        }
      }
      
      // どのパスでも見つからない場合は、デフォルトのパスを返す
      return 'cpu_monitor.dll';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void initCpuMonitor() {
    _initCpuMonitor();
  }

  int getCpuCount() {
    return _getCpuCount();
  }

  void updateCpuInfo() {
    _updateCpuInfo();
  }

  double getCpuUsage(int cpuIndex) {
    return _getCpuUsage(cpuIndex);
  }

  String getCpuName(int cpuIndex) {
    final namePtr = _getCpuName(cpuIndex);
    if (namePtr.address == 0) {
      return 'Unknown';
    }
    final name = namePtr.toDartString();
    _freeString(namePtr);
    return name;
  }
}
