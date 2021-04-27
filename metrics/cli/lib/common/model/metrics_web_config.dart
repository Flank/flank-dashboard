// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/sentry/model/sentry_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [MetricsConfig] implementation.
class MetricsWebConfig implements MetricsConfig {
  /// A Google sign in client id variable name.
  static const String googleSignInClientIdName = 'GOOGLE_SIGN_IN_CLIENT_ID';

  /// A Sentry configuration.
  final SentryConfig sentryConfig;

  @override
  final String googleSignInClientId;

  @override
  String get sentryDsn => sentryConfig?.dsn;

  @override
  String get sentryEnvironment => sentryConfig?.environment;

  @override
  String get sentryRelease => sentryConfig?.release;

  /// Creates a new instance of the [MetricsConfig] with the given parameters.
  MetricsWebConfig({
    this.googleSignInClientId,
    this.sentryConfig,
  });

  /// Maps the [MetricsConfig] to the [Map].
  Map<String, String> toMap() {
    return {
      googleSignInClientIdName: googleSignInClientId,
      SentryConfig.dsnName: sentryDsn,
      SentryConfig.environmentName: sentryEnvironment,
      SentryConfig.releaseName: sentryRelease,
    };
  }
}
