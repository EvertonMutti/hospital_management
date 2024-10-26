import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SystemInfo{
  static final SystemInfo _instance = SystemInfo._internal();
  factory SystemInfo() => _instance;
  SystemInfo._internal();


  static Future<bool> isAndroid11OrHigher() async {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt >= 30;
      }
      return false;
    }

  static Future<bool> isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33;
    }
    return false;
  }

  static Future<bool> requestStoragePermission() async {
    PermissionStatus status;

    if (await isAndroid13OrHigher()) {
      status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
    } else {
      status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    }

    return status.isGranted;
  }
}