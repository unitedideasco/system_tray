import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:system_tray_platform_interface/system_tray_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
     SystemTrayPlatform.instance.initialize();

    await SystemTrayPlatform.instance
        .setIcon(iconPath: '/Users/jackstefansky/Downloads/test.png');
    await SystemTrayPlatform.instance.setMenu(trayActions: [
      TrayAction(
        actionType: TrayActionType.CustomEvent,
        callback: () => print('First option selected'),
        label: 'Test',
        name: 'test',
      ),
      TrayAction(
        actionType: TrayActionType.CustomEvent,
        callback: () => print('Second option selected'),
        label: 'Test',
        name: 'test1',
      ),
      TrayAction(
        actionType: TrayActionType.CustomEvent,
        callback: () => print('Third option selected'),
        label: 'Test',
        name: 'test2',
      ),
    ]); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(child: Text('Test')),
      ),
    );
  }
}
