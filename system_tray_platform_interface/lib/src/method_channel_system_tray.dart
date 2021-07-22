// Copyright 2021 United Ideas. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:system_tray_platform_interface/src/types/tray_action.dart';

import 'system_tray_platform_interface.dart';
import 'types/types.dart';
import 'utils/utils.dart';

const MethodChannel _channel = MethodChannel('unitedideas.co/system_tray');

/// An implementation of [SystemTrayPlatform] that uses method channels.
class MethodChannelSystemTray extends SystemTrayPlatform {
  late List<TrayAction> trayActions;

  bool _initialized = false;

  @override
  void initialize() {
    WidgetsFlutterBinding.ensureInitialized();
    _channel.setMethodCallHandler((MethodCall call) async {
      final args = call.arguments;
      if (call.method == 'menu.handleMenuClick') {
        print('handleMenuClick');

        final menuItemName = args['name'] as String;

        trayActions
            .firstWhere((trayAction) => trayAction.name == menuItemName)
            .callback();
      } else {
        print("No handler defined for method type");

        assert(false, "No handler defined for method type: '${call.method}'");
      }
    });

    _initialized = true;
  }

  @override
  Future<void> setIcon({required String iconPath}) async {
    assert(_initialized);

    final trayIconFile = File(iconPath);
    final trayIconBytes = trayIconFile.readAsBytesSync();

    await _channel.invokeMethod<bool>(
      'setIcon',
      <String, Object>{
        'iconBytes': trayIconBytes,
        'iconBytesLength': trayIconBytes.length,
      },
    );
  }

  @override
  Future<void> setMenu({required List<TrayAction> trayActions}) async {
    assert(_initialized);

    this.trayActions = trayActions;
    var trayActionsJsonList = serializeTrayActions(trayActions);

    await _channel.invokeMethod<bool>(
      'setMenu',
      <String, Object>{
        'trayActions': trayActionsJsonList,
      },
    );
  }

  @override
  Future<List<SystemWindow>> getActiveApps() async {
    assert(_initialized);

    final activeAppsJson = await _channel.invokeMethod<String>(
      'getActiveApps',
      <String, Object>{},
    );

    final activeWindowsMap = jsonDecode(activeAppsJson!) as List;

    return activeWindowsMap
        .map((windowMap) => SystemWindow(
              name: windowMap['name'],
              isActive: windowMap['isActive'],
            ))
        .toList();
  }
}
