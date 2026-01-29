import '../../platform/permission_service.dart';

class RequestPermissionUseCase {
  final PermissionService _service;
  RequestPermissionUseCase(this._service);

  Future<bool> requestCamera() => _service.requestCameraPermission();
  Future<bool> requestLocation() => _service.requestLocationPermission();
}
