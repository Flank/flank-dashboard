// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// An enum representing device ids that Flutter can run applications on.
///
/// The following devices are currently supported: chrome, web-server (default)
class Device extends Enum<String> {
  static const Device chrome = Device._("chrome");
  static const Device webServer = Device._("web-server");

  const Device._(String deviceId) : super(deviceId);
}
