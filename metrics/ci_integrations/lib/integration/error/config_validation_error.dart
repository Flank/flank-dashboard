// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:meta/meta.dart';

/// A class that represents a [Config] validation error.
@immutable
class ConfigValidationError extends Error {
  /// A [String] description of this error.
  final String message;

  /// Creates an instance of the [ConfigValidationError]
  /// with the given [message].
  ConfigValidationError({
    this.message,
  });

  @override
  String toString() {
    String errorMessage = 'An error occurred during config validation.';

    if (message != null) {
      errorMessage = '$errorMessage \n$message';
    }

    return errorMessage;
  }
}
