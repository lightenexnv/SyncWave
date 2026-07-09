import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncwave/main.dart';

void main() {
  testWidgets('SyncWave app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SyncWaveApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
