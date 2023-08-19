import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    var statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      return true;
    } else {
      _handleInvalidPermissions(
        statuses[Permission.camera]!,
        statuses[Permission.microphone]!,
      );
      return false;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus.isDenied && microphonePermissionStatus.isDenied) {
      throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and microphone denied",
        details: null,
      );
    } else if (
        cameraPermissionStatus.isPermanentlyDenied &&
        microphonePermissionStatus.isPermanentlyDenied) {
      throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null,
      );
    }
  }
}
