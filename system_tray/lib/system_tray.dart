
import 'dart:async';

import 'package:flutter/services.dart';

class SystemTray {
  static const MethodChannel _channel = MethodChannel('system_tray');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
