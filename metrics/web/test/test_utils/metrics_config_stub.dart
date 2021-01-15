import 'package:metrics/common/domain/entities/metrics_config.dart';

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
