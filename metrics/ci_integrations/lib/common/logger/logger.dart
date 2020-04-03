import 'dart:io';

/// A class providing methods for logging messages and errors for CLI tool.
class Logger {
  /// The [IOSink] used to log errors.
  final IOSink errorSink;

  /// The [IOSink] used to log messages.
  final IOSink messageSink;

  /// Creates the logger instance.
  ///
  /// Both [errorSink] and [messageSink] are optional.
  /// If [errorSink] is not given, the default [stderr] is used.
  /// If [messageSink] is not given, the default [stdout] is used.
  Logger({
    IOSink errorSink,
    IOSink messageSink,
  })  : errorSink = errorSink ?? stderr,
        messageSink = messageSink ?? stdout;

  /// Prints the given [error] to the [errorSink].
  void printError(Object error) => errorSink.writeln(error);

  /// Prints the given [message] to the [messageSink].
  void printMessage(Object message) => messageSink.writeln(message);
}
