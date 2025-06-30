import 'dart:async';
import 'package:flutter/material.dart';
import 'cpu_monitor_bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Flutter Rust CPU',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CpuMonitorScreen(),
    );
  }
}

class CpuMonitorScreen extends StatefulWidget {
  const CpuMonitorScreen({super.key});

  @override
  State<CpuMonitorScreen> createState() => _CpuMonitorScreenState();
}

class _CpuMonitorScreenState extends State<CpuMonitorScreen> {
  late CpuMonitorBindings _cpuMonitor;
  Timer? _timer;
  int _cpuCount = 0;
  List<double> _cpuUsages = [];
  List<String> _cpuNames = [];
  bool _isInitialized = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeCpuMonitor();
  }

  void _initializeCpuMonitor() {
    try {
      _cpuMonitor = CpuMonitorBindings();
      _cpuMonitor.initCpuMonitor();
      
      _cpuCount = _cpuMonitor.getCpuCount();
      _cpuUsages = List.filled(_cpuCount, 0.0);
      _cpuNames = [];
      
      for (int i = 0; i < _cpuCount; i++) {
        _cpuNames.add(_cpuMonitor.getCpuName(i));
      }

      setState(() {
        _isInitialized = true;
      });

      // 0.5秒ごとにCPU使用率を更新
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _updateCpuUsages();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing CPU monitor: $e';
      });
    }
  }

  void _updateCpuUsages() {
    try {
      _cpuMonitor.updateCpuInfo();
      
      final newUsages = <double>[];
      for (int i = 0; i < _cpuCount; i++) {
        newUsages.add(_cpuMonitor.getCpuUsage(i));
      }
      
      setState(() {
        _cpuUsages = newUsages;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating CPU usage: $e';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('CPU Monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.memory, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CPU Count',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '$_cpuCount cores',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'CPU Usage (%)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getGridColumns(),
              mainAxisExtent: 80.0, // 固定の高さを指定
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _cpuCount,
            itemBuilder: (context, index) {
              final usage = _cpuUsages[index];
              final cpuName = _cpuNames.isNotEmpty ? _cpuNames[index] : 'CPU $index';
              
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              cpuName != 'CPU $index' ? cpuName : 'CPU $index',
                              style: Theme.of(context).textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${usage.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getUsageColor(usage),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: usage / 100.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getUsageColor(usage),
                        ),
                        minHeight: 6.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int _getGridColumns() {
    if (_cpuCount <= 8) {
      return 1; // 8個以下: 1列
    } else if (_cpuCount <= 16) {
      return 2; // 9-16個: 2列
    } else {
      return 3; // 17個以上: 3列
    }
  }

  Color _getUsageColor(double usage) {
    if (usage < 30) {
      return Colors.green;
    } else if (usage < 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
