// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Sentry Web configuration.
class SentryWebConfig extends Equatable {
  /// A Sentry project DSN.
  final String dsn;

  /// A Sentry environment indicates the environment or the release stage.
  final String environment;

  /// A Sentry release name.
  final String release;

  @override
  List<Object> get props => [dsn, environment, release];

  /// Creates a new instance of the [SentryWebConfig] with the given parameters.
  const SentryWebConfig({this.dsn, this.environment, this.release});
}
