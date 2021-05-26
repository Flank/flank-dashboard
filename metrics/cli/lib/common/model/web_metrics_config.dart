// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/sentry_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// An implementation of the [MetricsConfig] for Metrics Web application.
class WebMetricsConfig implements MetricsConfig {
  /// A Google sign in client id variable name.
  static const String googleSignInClientIdName = 'GOOGLE_SIGN_IN_CLIENT_ID';

  /// A Sentry project DSN variable name.
  static const String sentryDsnName = 'SENTRY_DSN';

  /// A Sentry environment variable name.
  static const String sentryEnvironmentName = "SENTRY_ENVIRONMENT";

  /// A Sentry release variable name.
  static const String sentryReleaseName = "SENTRY_RELEASE";

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

  /// Creates a new instance of the [WebMetricsConfig] with the given parameters.
  WebMetricsConfig({
    this.googleSignInClientId,
    this.sentryConfig,
  });

  /// Converts this [WebMetricsConfig] to the [Map].
  Map<String, String> toMap() {
    return {
      googleSignInClientIdName: googleSignInClientId,
      sentryDsnName: sentryDsn,
      sentryEnvironmentName: sentryEnvironment,
      sentryReleaseName: sentryRelease,
    };
  }
}
