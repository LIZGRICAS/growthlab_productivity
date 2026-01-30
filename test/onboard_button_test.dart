import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:growthlab_productivity/presentation/pages/growth_page.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_bloc.dart';
import 'package:growthlab_productivity/domain/entities.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepo mockRepo;

  setUpAll(() {
    registerFallbackValue(const UserProfile(name: 'X', identity: '0', email: 'x@x.com', phone: '0'));
  });

  setUp(() {
    mockRepo = MockAnalyticsRepo();
  });

  testWidgets('Onboard User button creates profile with expected data', (tester) async {
    when(() => mockRepo.createUserProfile(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<GrowthBloc>(
          create: (_) => GrowthBloc(repository: mockRepo),
          child: const GrowthPage(),
        ),
      ),
    );

    // Ensure widgets built
    await tester.pumpAndSettle();

    // Tap the Onboard User card
    final onboardFinder = find.text('Onboard User');
    expect(onboardFinder, findsOneWidget);
    await tester.tap(onboardFinder);
    await tester.pumpAndSettle();

    // Expected profile per request
    const expected = UserProfile(
      name: 'Lizbeth Grisales Castro',
      identity: '1036626480',
      email: 'lizgricas@gmail.con',
      phone: '+573008333775',
    );

    verify(() => mockRepo.createUserProfile(expected)).called(1);
  });
}
