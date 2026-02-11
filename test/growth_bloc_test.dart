/*
  Test: growth_bloc_test.dart

  Propósito:
  - Verificar el flujo del `GrowthBloc` cuando se dispara el evento
    `CreateUserRequested`.

  Nota:
  - Se inyectan los usecases construidos con un `MockAnalyticsRepo` para
    comprobar la cadena `Bloc -> UseCase -> Repository` sin tocar infraestructura real.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:growthlab_productivity/presentation/bloc/growth_bloc.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_event.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_state.dart';
import 'package:growthlab_productivity/domain/entities/user_profile.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';
import 'package:growthlab_productivity/domain/usecases/growth_usecases.dart';
import 'package:growthlab_productivity/domain/usecases/update_user_profile_use_case.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepo mockRepo;

  setUpAll(() {
    registerFallbackValue(UserProfile(name: 'X', identity: '0', email: 'x@x.com', phone: '0'));
  });

  setUp(() {
    mockRepo = MockAnalyticsRepo();
  });

  test('CreateUserRequested calls repository and results in success state', () async {
    when(() => mockRepo.createUserProfile(any())).thenAnswer((_) async {});
    final bloc = GrowthBloc(
      createUser: CreateUserProfileUseCase(mockRepo),
      trackEvent: TrackProductivityUseCase(mockRepo),
      syncData: SyncDataUseCase(mockRepo),
      updateProfile: UpdateUserProfileUseCase(mockRepo),
    );
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
