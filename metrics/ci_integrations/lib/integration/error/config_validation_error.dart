/// A class that represents a [Config] validation error.
class ConfigValidationError implements Error {
  /// A [String] description of this error.
  final String message;

  /// Creates an instance of the [ConfigValidationError]
  /// with the given [message].
  const ConfigValidationError({
    this.message,
  });

  @override
  String toString() {
    final errorMessage = message ?? '';

    return "An error occurred during config validation: $errorMessage";
  }

  @override
  StackTrace get stackTrace => StackTrace.current;
}
