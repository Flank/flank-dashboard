// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

@JS()
library metrics_config;

import 'package:js/js.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [MetricsConfig] implementation for web.
@JS('MetricsConfig')
class WebMetricsConfig implements MetricsConfig {
  @override
  external String get googleSignInClientId;

  @override
  external String get sentryDsn;

  @override
  external String get sentryEnvironment;

  @override
  external String get sentryRelease;

  /// Creates a new instance of the [WebMetricsConfig].
  external WebMetricsConfig();
}
