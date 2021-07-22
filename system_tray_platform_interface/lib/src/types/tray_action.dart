// Copyright 2021 United Ideas. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'tray_action_type.dart';

/// Definition of tray action
class TrayAction {
  /// Creates a new tray action with the given properties.
  TrayAction({
    required this.actionType,
    required this.name,
    required this.label,
    required this.callback,
  });

  /// Defines function of the tray action
  final TrayActionType actionType;

  /// Name that identifies the tray action
  final String name;

  /// Visible title of the tray action
  final String label;

  /// Function invoked after menu item has been clicked
  final Function callback;

  Map<String, String> serialize() {
    return <String, String>{
      "actionType": this.actionType.index.toString(),
      "name": this.name,
      "label": this.label,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrayAction &&
          actionType == other.actionType &&
          name == other.name &&
          label == other.label &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => actionType.hashCode ^ name.hashCode ^ label.hashCode;

  @override
  String toString() {
    return '$runtimeType($actionType, $name, $label)';
  }
}
