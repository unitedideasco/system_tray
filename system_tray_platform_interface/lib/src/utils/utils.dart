// Copyright 2021 United Ideas. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:system_tray_platform_interface/src/types/tray_action.dart';

List<Map<String, String>> serializeTrayActions(List<TrayAction> actions) {
  List<Map<String, String>> result = <Map<String, String>>[];

  actions.forEach((TrayAction element) {
    result.add(element.serialize());
  });

  return result;
}
