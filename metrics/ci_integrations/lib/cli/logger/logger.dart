import 'dart:io';

/// A class providing methods for logging messages and errors for the CLI tool.
class Logger {
  /// The [IOSink] used to log errors.
  static IOSink _errorSink = stderr;

  /// The [IOSink] used to log messages.
  static IOSink _messageSink = stdout;

  /// Determine whether to print out logs to the [_messageSink].
  static bool _verbose = false;

  /// Configure this logger with the given [errorSink], [messageSink]
  /// and the [verbose] values.
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
  }

  /// Prints the given [error] to the [errorSink].
  static void printError(Object error) => _errorSink.writeln(error);

  /// Prints the given [message] to the [messageSink].
  static void printMessage(Object message) => _messageSink.writeln(message);

  /// Prints the given [message] to the [messageSink] if the verbose is `true`.
  static void printLog(Object message) {
    if (_verbose) _messageSink.writeln(message);
  }
}
