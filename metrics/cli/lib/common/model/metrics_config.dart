// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that represents a Metrics config.
class MetricsConfig {
  /// A Google sign in client id variable name.
  static const String googleSignInClientIdName = 'GOOGLE_SIGN_IN_CLIENT_ID';

  /// A Sentry project DSN variable name.
  static const String sentryDsnName = 'SENTRY_DSN';

  /// A Sentry environment variable name.
  static const String sentryEnvironmentName = "SENTRY_ENVIRONMENT";

  /// A Sentry release variable name.
  static const String sentryReleaseName = "SENTRY_RELEASE";

  /// A Google sign in client id used for Google Auth provider.
  final String googleSignInClientId;

  /// A Sentry project DSN.
  final String sentryDsn;

  /// A Sentry environment.
  final String sentryEnvironment;

  /// A Sentry release name.
  final String sentryRelease;

  /// Creates a new instance of the [MetricsConfig] with the given parameters.
  MetricsConfig({
    this.googleSignInClientId,
    this.sentryDsn,
    this.sentryEnvironment,
    this.sentryRelease,
  });

  /// Maps the [MetricsConfig] to the [Map].
  Map<String, String> toMap() {
    return {
      googleSignInClientIdName: googleSignInClientId,
      sentryDsnName: sentryDsn,
      sentryEnvironmentName: sentryEnvironment,
      sentryReleaseName: sentryRelease,
    };
  }
}
