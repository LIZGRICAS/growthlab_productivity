/*
  Test: growth_usecases_test.dart

  Propósito:
  - Verificar el comportamiento de los usecases del dominio:
    * CreateUserProfileUseCase
    * TrackProductivityUseCase
    * SyncDataUseCase

  Estrategia:
  - Se utiliza un `MockAnalyticsRepo` para comprobar que cada usecase
    invoque la llamada esperada al repositorio.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:growthlab_productivity/domain/usecases/growth_usecases.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';
import 'package:growthlab_productivity/domain/entities/user_profile.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepo mockRepo;

  setUp(() {
    mockRepo = MockAnalyticsRepo();
  });

  setUpAll(() {
    // Fallback para mocktail
    registerFallbackValue(UserProfile(name: 'X', identity: '0', email: 'x@x.com', phone: '0'));
  });

  test('CreateUserProfileUseCase calls repository.createUserProfile', () async {
    final usecase = CreateUserProfileUseCase(mockRepo);
    final profile = UserProfile(name: 'X', identity: '1', email: 'e@x.com', phone: '99');

    // Mock del repositorio y ejecución
    when(() => mockRepo.createUserProfile(any())).thenAnswer((_) async {});

    await usecase(profile);

    // Verificamos que el repositorio recibió exactamente el perfil enviado
    verify(() => mockRepo.createUserProfile(profile)).called(1);
  });

  test('TrackProductivityUseCase calls trackProductivityEvent with Hola_mundo', () async {
    final usecase = TrackProductivityUseCase(mockRepo);

    when(() => mockRepo.trackProductivityEvent(any(), any())).thenAnswer((_) async {});

    await usecase();

    // Verificamos que el evento 'Hola_mundo' fue enviado al repositorio
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
