// Copyright 2021 United Ideas. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:system_tray_platform_interface/system_tray_platform_interface.dart';

/// Discover network connectivity configurations: Distinguish between WI-FI and cellular, check WI-FI status and more.
class SystemTray {
  /// Constructs a singleton instance of [SystemTray].
  ///
  /// [SystemTray] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory SystemTray() {
    if (_singleton == null) {
      _singleton = SystemTray._();
    }
    return _singleton!;
  }

  SystemTray._();

  static SystemTray? _singleton;

  static SystemTrayPlatform get _platform => SystemTrayPlatform.instance;

  void initialize() {
    _platform.initialize();
  }

  Future<void> setIcon({required String iconPath}) async {
    await _platform.setIcon(iconPath: iconPath);
  }

  Future<void> setMenu({required List<TrayAction> trayActions}) async {
    await _platform.setMenu(trayActions: trayActions);
  }

  Future<List<SystemWindow>> getActiveApps() async {
    return _platform.getActiveApps();
  }
}
