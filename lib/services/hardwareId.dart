import 'dart:io';

import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HardwareIdGenerator {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String?> generateHardwareId() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidId();
      } else if (Platform.isIOS) {
        return await _getIosId();
      }
    } catch (e) {
      print('Error generating hardware ID: $e');
    }
    return null;
  }

  Future<String> _getAndroidId() async {
    AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    String androidId = androidInfo.id;
    String brand = androidInfo.brand;
    String model = androidInfo.model;

    // Combine ANDROID_ID with device info for added uniqueness
    String combinedInfo = '$androidId:$brand:$model';
    return _generateHash(combinedInfo);
  }

  Future<String> _getIosId() async {
    IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
    // Use identifierForVendor as it's the most reliable option on iOS
    String? idForVendor = iosInfo.identifierForVendor;
    if (idForVendor == null) {
      throw PlatformException(code: 'NO_ID', message: 'Unable to get iOS identifier');
    }
    return _generateHash(idForVendor);
  }

  String _generateHash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}