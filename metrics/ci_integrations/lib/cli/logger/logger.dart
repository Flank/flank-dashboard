import 'dart:io';

/// A class providing methods for logging messages and errors for the CLI tool.
class Logger {
  /// The [IOSink] used to log errors.
  static IOSink _errorSink = stderr;

  /// The [IOSink] used to log messages.
  static IOSink _messageSink = stdout;

  /// Determine whether to print out logs to the [_messageSink].
  static bool _verbose = false;

  /// Determine whether the [setup] method of this logger is invoked.
  static bool _isInitialized;

  /// Configure this logger with the given [errorSink], [messageSink]
  /// and the [verbose] values.
  ///
  /// Sets the [Logger] initialize status to `true`.
  ///
  /// If the given [errorSink] is `null`, the [stderr] is used.
  /// If the given [messageSink] is `null`, the [stdout] is used.
  /// If the given [verbose] is `null`, the `false` is used.
  static void setup({
    IOSink errorSink,
    IOSink messageSink,
    bool verbose,
  }) {
    _errorSink = errorSink ?? stderr;
    _messageSink = messageSink ?? stdout;
    _verbose = verbose ?? false;
    _isInitialized = true;
  }

  /// Prints the given [error] to the [errorSink].
  ///
  /// Throws an [Exception] if the [Logger] is not initialized.
  static void logError(Object error) {
    _checkInitialized();

    _errorSink.writeln(error);
  }

  /// Prints the given [message] to the [messageSink].
  ///
  /// Throws an [Exception] if the [Logger] is not initialized.
  static void logMessage(Object message) {
    _checkInitialized();

    _messageSink.writeln(message);
  }

  /// Prints the given [message] to the [messageSink] if the verbose is `true`.
  ///
  /// Throws an [Exception] if the [Logger] is not initialized.
  static void logInfo(Object message) {
    _checkInitialized();

    if (_verbose) _messageSink.writeln("[${DateTime.now()}] $message");
  }

  /// Throws an [Exception] if the [_isInitialized] is `false`.
  static void _checkInitialized() {
    if (!_isInitialized) throw Exception('The Logger is not initialized');
  }
}
