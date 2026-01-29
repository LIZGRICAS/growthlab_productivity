import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:growthlab_productivity/presentation/widgets/lifecycle_listener.dart';

void main() {
  testWidgets('LifecycleListener receives lifecycle changes', (WidgetTester tester) async {
    AppLifecycleState? received;

    await tester.pumpWidget(MaterialApp(
      home: LifecycleListener(
        onStateChanged: (s) => received = s,
        child: const Scaffold(body: Text('ok')),
      ),
    ));

    // Simulate lifecycle change
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();

    expect(received, AppLifecycleState.paused);
  });
}
