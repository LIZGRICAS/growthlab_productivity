import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:growthlab_productivity/presentation/bloc/growth_bloc.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_event.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_state.dart';
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

  test('CreateUserRequested calls repository and results in success state', () async {
    when(() => mockRepo.createUserProfile(any())).thenAnswer((_) async {});

    final bloc = GrowthBloc(repository: mockRepo);
    bloc.add(CreateUserRequested());

    // Wait until state becomes success or timeout
    var attempts = 0;
    while (bloc.state.status != GrowthStatus.success && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 50));
      attempts++;
    }

    expect(bloc.state.status, GrowthStatus.success);
    expect(bloc.state.user, isNotNull);
    verify(() => mockRepo.createUserProfile(any())).called(1);
    await bloc.close();
  });
}
