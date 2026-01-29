import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:growthlab_productivity/platform/permission_service.dart';
import 'package:growthlab_productivity/domain/usecases/request_permission_usecase.dart';

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockPermissionService mockService;
  late RequestPermissionUseCase usecase;

  setUp(() {
    mockService = MockPermissionService();
    usecase = RequestPermissionUseCase(mockService);
  });

  test('requestCamera returns true when service grants permission', () async {
    when(() => mockService.requestCameraPermission()).thenAnswer((_) async => true);

    final res = await usecase.requestCamera();

    expect(res, true);
    verify(() => mockService.requestCameraPermission()).called(1);
  });

  test('requestLocation returns false when service denies permission', () async {
    when(() => mockService.requestLocationPermission()).thenAnswer((_) async => false);

    final res = await usecase.requestLocation();

    expect(res, false);
    verify(() => mockService.requestLocationPermission()).called(1);
  });
}
