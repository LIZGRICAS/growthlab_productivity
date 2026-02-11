/*
  Test: navigation_flow_test.dart

  Propósito:
  - Test de widget que verifica la navegación desde `GrowthPage` hacia
    `DiagnosticsPage` al pulsar el icono correspondiente.

  Nota:
  - Se construye un `GrowthBloc` con usecases que usan un repo mockeado para
    evitar inicializar Firebase en los tests.
*/

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:growthlab_productivity/presentation/pages/growth_page.dart';
import 'package:growthlab_productivity/presentation/pages/diagnostics_page.dart';
import 'package:growthlab_productivity/presentation/bloc/growth_bloc.dart';
import 'package:growthlab_productivity/domain/repositories/analytics_repository.dart';
import 'package:growthlab_productivity/domain/entities/user_profile.dart';
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

  testWidgets('Tapping diagnostics icon navigates to DiagnosticsPage', (WidgetTester tester) async {
    // Construimos el Bloc usando los usecases que apuntan al repo mock
    final bloc = GrowthBloc(
      createUser: CreateUserProfileUseCase(mockRepo),
      trackEvent: TrackProductivityUseCase(mockRepo),
      syncData: SyncDataUseCase(mockRepo),
      updateProfile: UpdateUserProfileUseCase(mockRepo),
    );

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: bloc,
        child: const GrowthPage(),
      ),
    ));

    // Buscamos y pulsamos el icono de Diagnostics
    final diagnosticsFinder = find.byTooltip('Diagnostics');
    expect(diagnosticsFinder, findsOneWidget);

    await tester.tap(diagnosticsFinder);
    await tester.pumpAndSettle();

    // Comprobamos que la página de diagnostics se muestra
    expect(find.byType(DiagnosticsPage), findsOneWidget);
    expect(find.text('Diagnostics'), findsOneWidget);
  });
}
