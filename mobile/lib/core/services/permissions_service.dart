import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<void> prewarm() async {
    // Preload permission status to avoid UI jank.
    await Permission.notification.status;
  }

  Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> requestPhotos() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> openSettings() => openAppSettings();
}
