abstract class PermissionService {
  /// Requests camera permission. Returns true if granted.
  Future<bool> requestCameraPermission();

  /// Requests location permission. Returns true if granted.
  Future<bool> requestLocationPermission();
}
