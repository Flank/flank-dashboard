// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A utility class that provides methods for validating strings.
class StringValidator {
  /// Checks the given [value] to be not `null` or empty string.
  /// Uses the given [name] to create an error description if validation fails.
  ///
  /// Throws an [ArgumentError] if the [value] is either `null` or
  /// [String.isEmpty].
  static void checkNotNullOrEmpty(String value, {String name}) {
    if (value == null || value.isEmpty) {
      throw ArgumentError.value(value, name, 'must not be null or empty');
    }
  }
}
