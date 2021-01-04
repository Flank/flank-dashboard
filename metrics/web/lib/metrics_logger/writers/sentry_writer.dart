import 'dart:async';

import 'package:metrics/metrics_logger/writers/logger_writer.dart';
import 'package:sentry/sentry.dart';

/// A [LoggerWriter] implementation that uses the [Sentry] SDK and reports
/// errors to the Sentry.io.
class SentryWriter implements LoggerWriter {
  /// Creates an instance of the [SentryWriter].
  const SentryWriter._();

  /// Initializes [Sentry] with the given [dsn] and [release] values
  /// using [Sentry.init] method.
  ///
  /// Returns a new instance of the [SentryWriter].
  static Future<SentryWriter> init(String dsn, String release) async {
    await Sentry.init(
      (options) => options
        ..dsn = dsn
        ..release = release,
    );

    return const SentryWriter._();
  }

  @override
  void setContext(String key, dynamic context) {
    Sentry.configureScope((scope) => scope.setContexts(key, context));
  }

  @override
  Future<void> writeError(Object error, [StackTrace stackTrace]) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }
}
