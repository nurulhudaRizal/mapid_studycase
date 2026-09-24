import 'package:permission_handler/permission_handler.dart';

class LocationPermissionService {
  Future<bool> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      return false;
    }

    status = await Permission.locationWhenInUse.request();

    return status.isGranted;
  }

  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
