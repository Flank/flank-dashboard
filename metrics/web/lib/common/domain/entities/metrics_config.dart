/// A class representing a configuration that is used within the application.
abstract class MetricsConfig {
  /// A Data Source Name value that is used to configure Sentry.
  String get sentryDsn;

  /// A release property value that is used for Sentry initialization.
  String get sentryRelease;

  /// An environment property value that is used for Sentry initialization.
  String get sentryEnvironment;

  /// A unique ID of the client that is used to initialize Google Sign-In
  /// for the application.
  String get googleSignInClientId;
}
