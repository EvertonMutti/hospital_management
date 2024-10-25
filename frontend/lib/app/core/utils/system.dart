import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

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
}