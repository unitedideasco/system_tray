// Copyright 2021 United Ideas. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:system_tray_platform_interface/src/types/tray_action.dart';

import '../system_tray_platform_interface.dart';
import 'method_channel_system_tray.dart';

/// The interface that implementations of system_tray must implement.
///
/// Platform implementations should extend this class rather than implement it as `system_tray`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [SystemTrayPlatform] methods.
abstract class SystemTrayPlatform extends PlatformInterface {
  /// Constructs a SystemTrayPlatform.
  SystemTrayPlatform() : super(token: _token);

  static final Object _token = Object();

  static SystemTrayPlatform _instance = MethodChannelSystemTray();

  /// The default instance of [SystemTrayPlatform] to use.
  ///
  /// Defaults to [MethodChannelSystemTray].
  static SystemTrayPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SystemTrayPlatform] when they register themselves.
  static set instance(SystemTrayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes system tray plugin. Completes to [true] if the sttting or updating was successful.
  void initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Sets or updates system tray menu with given [trayActions]. Completes to [true] if the sttting or updating was successful.
  Future<void> setMenu({required List<TrayAction> trayActions}) {
    throw UnimplementedError('setMenu() has not been implemented.');
  }

  /// Sets or updates system tray icon with given [iconPath]. Completes to [true] if the setting or updating was successful.
  Future<void> setIcon({required String iconPath}) {
    throw UnimplementedError('setIcon() has not been implemented.');
  }

  /// Returns list of [SystemWindow]
  Future<List<SystemWindow>> getActiveApps() {
    throw UnimplementedError('getActiveApps() has not been implemented.');
  }

}