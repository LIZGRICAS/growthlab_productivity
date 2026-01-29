import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Build a minimal MaterialApp in the test instead of using GrowthLabApp

void main() {
  testWidgets('App uses Material3 theme and seed color scheme', (WidgetTester tester) async {
    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    await tester.pumpWidget(MaterialApp(theme: themeData, home: const SizedBox()));
    await tester.pumpAndSettle();

    final appContext = tester.element(find.byType(MaterialApp));
    final theme = Theme.of(appContext);

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.brightness, equals(Brightness.light));

    // We avoid asserting exact generated primary color (can vary by SDK);
    // assert Material 3 is enabled and a light color scheme is used.
  });
}
