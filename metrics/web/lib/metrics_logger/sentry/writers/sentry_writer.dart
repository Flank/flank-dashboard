// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:metrics/metrics_logger/sentry/event_processors/sentry_event_processor.dart';
import 'package:metrics/metrics_logger/writers/logger_writer.dart';
import 'package:sentry/sentry.dart';

/// A [LoggerWriter] implementation that uses the [Sentry] SDK and reports
/// errors to the Sentry.io.
class SentryWriter implements LoggerWriter {
  /// Creates an instance of the [SentryWriter].
  const SentryWriter._();

  /// Initializes [Sentry] with the given values using [Sentry.init] method.
  ///
  /// If the given [eventProcessor] is not `null`,
  /// adds it to the Sentry event processors using
  /// the [SentryOptions.addEventProcessor] method.
  ///
  /// Returns a new instance of the [SentryWriter].
  static Future<SentryWriter> init(
    String dsn,
    String release,
    String environment, {
    SentryEventProcessor eventProcessor,
  }) async {
    await Sentry.init((options) {
      options.dsn = dsn;
      options.release = release;
      options.environment = environment;

      if (eventProcessor != null) {
        options.addEventProcessor(eventProcessor);
      }
    });

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
