// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A stub implementation of the [MetricsConfig] to use in tests.
class MetricsConfigStub implements MetricsConfig {
  @override
  final String googleSignInClientId;

  @override
  final String sentryDsn;

  @override
  final String sentryEnvironment;

  @override
  final String sentryRelease;

  /// Creates a new instance of the [MetricsConfigStub].
  const MetricsConfigStub({
    this.googleSignInClientId,
    this.sentryDsn,
    this.sentryEnvironment,
    this.sentryRelease,
  });
}
