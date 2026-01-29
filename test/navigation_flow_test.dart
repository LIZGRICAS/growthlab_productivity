import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:growthlab_productivity/presentation/pages/growth_page.dart';
import 'package:growthlab_productivity/presentation/pages/diagnostics_page.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_bloc.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';
import 'package:growthlab_productivity/domain/entities.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepo mockRepo;

  setUpAll(() {
    registerFallbackValue(const UserProfile(name: 'X', identity: '0', email: 'x@x.com', phone: '0'));
  });

  setUp(() {
    mockRepo = MockAnalyticsRepo();
  });

  testWidgets('Tapping diagnostics icon navigates to DiagnosticsPage', (WidgetTester tester) async {
    // Provide a GrowthBloc that uses the mock repository to avoid Firebase initialization
    final bloc = GrowthBloc(repository: mockRepo);

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: bloc,
        child: const GrowthPage(),
      ),
    ));

    // Ensure the app bar and diagnostics icon exist
    final diagnosticsFinder = find.byTooltip('Diagnostics');
    expect(diagnosticsFinder, findsOneWidget);

    // Tap the diagnostics icon and wait for navigation
    await tester.tap(diagnosticsFinder);
    await tester.pumpAndSettle();

    // DiagnosticsPage should be on screen
    expect(find.byType(DiagnosticsPage), findsOneWidget);
    expect(find.text('Diagnostics'), findsOneWidget);
  });
}
