// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Sentry configuration.
class SentryConfig extends Equatable {
  /// A Sentry project DSN variable name.
  static const String dsnName = 'SENTRY_DSN';

  /// A Sentry environment variable name.
  static const String environmentName = "SENTRY_ENVIRONMENT";

  /// A Sentry release variable name.
  static const String releaseName = "SENTRY_RELEASE";

  /// A Sentry project DSN.
  final String dsn;

  /// A Sentry environment.
  final String environment;

  /// A Sentry release name.
  final String release;

  @override
  List<Object> get props => [dsn, environment, release];

  /// Creates a new instance of the [SentryConfig] with the given parameters.
  const SentryConfig({this.dsn, this.environment, this.release});
}
