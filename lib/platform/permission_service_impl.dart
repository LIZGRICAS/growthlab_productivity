import 'package:permission_handler/permission_handler.dart';

import 'permission_service.dart';

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }
}
