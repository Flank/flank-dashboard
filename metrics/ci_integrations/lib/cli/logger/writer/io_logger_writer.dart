// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:ci_integration/cli/logger/writer/logger_writer.dart';

/// An implementation of the [LoggerWriter] that uses [IOSink]s as logs output.
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
