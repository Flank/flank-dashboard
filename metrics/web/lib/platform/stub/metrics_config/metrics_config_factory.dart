// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A factory class stub implementation to support conditional imports.
class MetricsConfigFactory {
  /// Implemented in platform specific packages within `platform`.
  MetricsConfig create() {
    throw UnsupportedError(
      'Cannot create config without dart:html',
    );
  }
}
