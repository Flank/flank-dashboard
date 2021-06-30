// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/sentry_web_config.dart';
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
  final SentryWebConfig sentryWebConfig;

  @override
  final String googleSignInClientId;

  @override
  String get sentryDsn => sentryWebConfig?.dsn;

  @override
  String get sentryEnvironment => sentryWebConfig?.environment;

  @override
  String get sentryRelease => sentryWebConfig?.release;

  /// Creates a new instance of the [WebMetricsConfig] with the given parameters.
  WebMetricsConfig({
    this.googleSignInClientId,
    this.sentryWebConfig,
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
