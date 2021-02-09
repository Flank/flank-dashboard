// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// A class that represents a destination [Error].
@immutable
class DestinationError extends Error {
  /// A [String] description of this error.
  final String message;

  /// Creates a new instance of the [DestinationError].
  DestinationError({
    this.message,
  });

  @override
  String toString() {
    return message ?? '';
  }
}
