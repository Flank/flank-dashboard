import 'dart:io';

import 'package:intl/intl.dart';

/// A class providing methods for logging messages and errors for the CLI tool.
class Logger {
  /// The [IOSink] used to log errors.
  static IOSink _errorSink;

  /// The [IOSink] used to log messages.
  static IOSink _messageSink;

  /// A flag used to determine whether to enable info logs.
  static bool _verbose = false;

  /// Determine whether the [setup] method of this logger is invoked.
  static bool get _isInitialized =>
      _errorSink != null && _messageSink != null && _verbose != null;

  /// Configure this logger with the given [errorSink], [messageSink]
  /// and the [verbose] values.
  ///
  /// Sets the [Logger] initialize status to `true`.
  ///
  /// If the given [errorSink] is `null`, the [stderr] is used.
  /// If the given [messageSink] is `null`, the [stdout] is used.
  /// If the given [verbose] is `null`, `false` is used.
  static void setup({
    IOSink errorSink,
    IOSink messageSink,
    bool verbose,
  }) {
    _errorSink = errorSink ?? stderr;
    _messageSink = messageSink ?? stdout;
    _verbose = verbose ?? false;
  }

  /// Logs the given [error] to the error [IOSink].
  ///
  /// Throws a [StateError] if the [Logger] is not initialized.
  static void logError(Object error) {
    _checkInitialized();

    _errorSink.writeln(error);
  }

  /// Logs the given [message] to the message [IOSink].
  ///
  /// Throws a [StateError] if the [Logger] is not initialized.
  static void logMessage(Object message) {
    _checkInitialized();

    _messageSink.writeln(message);
  }

  /// Logs the given [message] to the message [IOSink] if the verbose is `true`.
  ///
  /// Throws a [StateError] if the [Logger] is not initialized.
  static void logInfo(Object message) {
    _checkInitialized();

    if (_verbose) {
      final dateTimeNow = DateFormat.yMd().add_Hms().format(DateTime.now());

      _messageSink.writeln("[$dateTimeNow] $message");
    }
  }

  /// Throws a [StateError] if the [_isInitialized] is `false`.
  static void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'The Logger is not set up. The setup method must be called before calling any other methods of the Logger.',
      );
    }
  }
}
