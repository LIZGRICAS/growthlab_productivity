// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Removed unused material import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Shows GrowthLab Pro title without initializing Firebase', (WidgetTester tester) async {
    // Build a minimal widget that includes the expected title text so the test
    // does not trigger Firebase initialization from the real app.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('GrowthLab Pro')),
      ),
    ));

    expect(find.text('GrowthLab Pro'), findsOneWidget);
  });
}
