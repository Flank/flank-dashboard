// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/metrics_logger/writers/logger_writer.dart';

/// A [LoggerWriter] implementation that [print]s errors with their contexts.
class ConsoleWriter implements LoggerWriter {
  /// A [Map] that stores current contexts for this writer.
  final Map<String, dynamic> _contexts = {};

  @override
  void setContext(String key, dynamic context) {
    _contexts[key] = context;
  }

  @override
  void writeError(Object error, [StackTrace stackTrace]) {
    final buffer = StringBuffer();
    buffer.writeln('$error');

    if (_contexts.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('The error context was:');
      for (final entry in _contexts.entries) {
        buffer.writeln('${entry.key}: ${entry.value}');
      }
    }

    if (stackTrace != null) {
      buffer.writeln();
      buffer.writeln('The error stack trace was:');
      buffer.writeln(stackTrace);
    }

    print(buffer);
  }
}
