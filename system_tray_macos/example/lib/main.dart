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
  var windowsToShow = List<Window>.empty();
  var ticks = 0;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    SystemTrayPlatform.instance.initialize();

    Timer.periodic(const Duration(milliseconds: 20), (timer) async {
      final activeApps = await SystemTrayPlatform.instance.getActiveApps();

      print(activeApps.length);
      final wl = activeApps.map((w) => Window(w.name, w.isActive, 0)).toList();

      if (windowsToShow.isEmpty) {
        windowsToShow = wl;
      }

      for (var element in wl) {
        if (element.isActive) {
          windowsToShow
              .firstWhere((window) => window.name == element.name)
              .activityForce++;
        }
      }
      setState(() => ticks++);
    });

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
        body: ListView.builder(
          itemCount: windowsToShow.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: windowsToShow[index].activityForce,
                    child: Container(
                      height: 30.0,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    flex: ticks - windowsToShow[index].activityForce,
                    child: Container(
                      height: 30,
                    ),
                  ),
                ],
              ),
              Text(windowsToShow[index].name),
            ],
          ),
        ),
      ),
    );
  }
}

class Window {
  Window(
    this.name,
    this.isActive,
    this.activityForce,
  );

  String name;
  bool isActive;
  int activityForce;
}
