/// A class that represents a [Config] validation exception.
class ConfigValidationException implements Exception {
  /// A [String] description of this exception.
  final String message;

  /// Creates an instance of the [ConfigValidationException]
  /// with the given [message].
  const ConfigValidationException({
    this.message,
  });

  @override
  String toString() {
    return message ?? '';
  }
}
