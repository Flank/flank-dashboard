import 'dart:async';

/// An abstract class for logger writers that provide methods to write errors
/// and their contexts to the logs output.
abstract class LoggerWriter {
  /// Writes the given [error] and its optionally [stackTrace] to the
  /// logs output.
  ///
  /// This method should use the current contexts and attach them to
  /// the given [error] and [stackTrace] within the output.
  FutureOr<void> writeError(Object error, [StackTrace stackTrace]);

  /// Sets the context with the given [key] to the given [context] value.
  FutureOr<void> setContext(String key, dynamic context);
}
