/// A util class that provides methods for validating strings
class StringValidator {
  /// Checks the [value] to be not null or empty.
  ///
  /// Throws an [ArgumentError.value] if the [value] is either `null` or
  /// [value.isEmpty].
  ///
  /// Uses the given [name] to create an error description.
  static void checkNotNullOrEmpty(String value, {String name}) {
    if (value == null || value.isEmpty) {
      throw ArgumentError.value(value, name, 'must not be null or empty');
    }
  }
}
