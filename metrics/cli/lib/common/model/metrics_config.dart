// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/sentry/model/sentry_config.dart';

/// A class that represents a Metrics configuration.
class MetricsConfig {
  /// A Google sign in client id variable name.
  static const String googleSignInClientIdName = 'GOOGLE_SIGN_IN_CLIENT_ID';

  /// A Google sign in client id used for Google Auth provider.
  final String googleSignInClientId;

  /// A Sentry configuration.
  final SentryConfig sentryConfig;

  /// Creates a new instance of the [MetricsConfig] with the given parameters.
  MetricsConfig({
    this.googleSignInClientId,
    this.sentryConfig,
  });

  /// Maps the [MetricsConfig] to the [Map].
  Map<String, String> toMap() {
    final sentry = sentryConfig ?? const SentryConfig();

    return {
      googleSignInClientIdName: googleSignInClientId,
      ...sentry.toMap(),
    };
  }
}
