// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A class that provides methods to configure the web application.
class PlatformConfiguration {
  /// Configures the web application url strategy.
  static void configureApp() {
    setUrlStrategy(PathUrlStrategy());
  }
}
