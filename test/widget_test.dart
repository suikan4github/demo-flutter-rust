// This is a basic Flutter widget test for CPU Monitor Demo.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demo_flutter_rust_cpu/main.dart';

void main() {
  testWidgets('CPU Monitor app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app has the correct title
    expect(find.text('CPU Monitor'), findsOneWidget);

    // The app might show error or loading state initially in test environment
    // since FFI might not work in test mode
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('App structure test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check if the main components exist
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CpuMonitorScreen), findsOneWidget);
  });
}
