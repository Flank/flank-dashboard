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
    final errorMessage = message ?? '';

    return "An error occurred during config validation: $errorMessage";
  }
}
