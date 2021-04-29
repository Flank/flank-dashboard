// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class representing a configuration that is used within the application.
abstract class MetricsConfig {
  /// A unique ID of the client that is used to initialize Google Sign-In
  /// for the application.
  String get googleSignInClientId;

  /// A Data Source Name value that is used to configure Sentry.
  String get sentryDsn;

  /// An environment property value that is used for Sentry initialization.
  String get sentryEnvironment;

  /// A release property value that is used for Sentry initialization.
  String get sentryRelease;
}
