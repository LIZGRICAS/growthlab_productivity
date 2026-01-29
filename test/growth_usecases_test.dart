import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:growthlab_productivity/domain/usecases/growth_usecases.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';
import 'package:growthlab_productivity/domain/entities.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepo mockRepo;

  setUp(() {
    mockRepo = MockAnalyticsRepo();
  });

  setUpAll(() {
    registerFallbackValue(const UserProfile(name: 'X', identity: '0', email: 'x@x.com', phone: '0'));
  });

  test('CreateUserProfileUseCase calls repository.createUserProfile', () async {
    final usecase = CreateUserProfileUseCase(mockRepo);
    final profile = const UserProfile(name: 'X', identity: '1', email: 'e@x.com', phone: '99');

    when(() => mockRepo.createUserProfile(any())).thenAnswer((_) async {});

    await usecase(profile);

    verify(() => mockRepo.createUserProfile(profile)).called(1);
  });

  test('TrackProductivityUseCase calls trackProductivityEvent with Hola_mundo', () async {
    final usecase = TrackProductivityUseCase(mockRepo);

    when(() => mockRepo.trackProductivityEvent(any(), any())).thenAnswer((_) async {});

    await usecase();

    verify(() => mockRepo.trackProductivityEvent('Hola_mundo', any())).called(1);
  });

  test('SyncDataUseCase returns list from repository', () async {
    final usecase = SyncDataUseCase(mockRepo);

    when(() => mockRepo.syncExternalData()).thenAnswer((_) async => ['1','2']);

    final res = await usecase();

    expect(res, ['1','2']);
    verify(() => mockRepo.syncExternalData()).called(1);
  });
}
