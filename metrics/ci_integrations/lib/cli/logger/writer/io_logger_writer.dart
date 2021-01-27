import 'dart:io';

import 'package:ci_integration/cli/logger/writer/logger_writer.dart';

/// The implementation of the [LoggerWriter] that uses [IOSink]s as logs output.
class IOLoggerWriter implements LoggerWriter {
  /// An [IOSink] this writer uses to write messages.
  final IOSink messageSink;

  /// Creates a new instance of the [IOLoggerWriter].
  ///
  /// If the given [messageSink] is `null`, the [stdout] is used.
  IOLoggerWriter({
    IOSink messageSink,
  }) : messageSink = messageSink ?? stdout;

  @override
  void write(Object message) {
    messageSink.writeln(message);
  }
}
