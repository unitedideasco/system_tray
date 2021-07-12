// Copyright 2021 United Ideas. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The possible tray actions types that can be set for a tray action
enum TrayActionType {
  /// Action will trigger application shutdown
  Quit,

  /// Action will trigger GLFW `window.Show` and bring flutter app to front
  Focus,

  /// Action will trigger an event that will call a registered callback in flutter app
  CustomEvent,
}
