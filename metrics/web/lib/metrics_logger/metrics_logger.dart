// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/metrics_logger/writers/logger_writer.dart';

/// A class that provides methods for logging errors together with
/// their contexts using a [LoggerWriter].
///
/// Before calling any methods, this should be initialized with the
/// [LoggerWriter] using the [MetricsLogger.initialize] method.
class MetricsLogger {
  /// A [LoggerWriter] this logger uses to write errors and their contexts
  /// to the logger output.
  static LoggerWriter _writer;

  /// Initializes this logger with the given [writer] and
  /// optionally [contexts] of the application.
  ///
  /// Throws an [AssertionError] if the given [writer] is `null`.
  static Future<void> initialize(
    LoggerWriter writer, {
    Map<String, dynamic> contexts,
  }) async {
    assert(writer != null);
    _writer = writer;

    if (contexts == null) return;

    final futures = <Future>[];

    for (final entry in contexts.entries) {
      futures.add(setContext(entry.key, entry.value));
    }

    await Future.wait(futures);
  }

  /// Sets the context with the given [key] to the given [context] value.
  ///
  /// Throws an [AssertionError] if the current
  /// [LoggerWriter] instance is `null`.
  static Future<void> setContext(String key, dynamic context) async {
    assert(_writer != null);

    return _writer?.setContext(key, context);
  }

  /// Logs the given [error] and its optionally [stackTrace].
  ///
  /// Throws an [AssertionError] if the current
  /// [LoggerWriter] instance is `null`.
  static Future<void> logError(Object error, [StackTrace stackTrace]) async {
    assert(_writer != null);

    return _writer?.writeError(error, stackTrace);
  }
}
