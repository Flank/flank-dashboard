// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/platform/web/metrics_config/web_metrics_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A factory class that creates instances of [WebMetricsConfig].
class MetricsConfigFactory {
  /// Creates a new instance of the [WebMetricsConfig].
  MetricsConfig create() {
    return WebMetricsConfig();
  }
}
