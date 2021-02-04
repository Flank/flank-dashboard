// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/writer/io_logger_writer.dart';
import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/cli/logger/writer/logger_writer.dart';

/// A factory class that creates new instances of the [Logger] using
/// the specified parameters.
class LoggerFactory {
  /// A [LoggerWriter] to use to create new instances of [Logger].
  final LoggerWriter writer;

  /// A verbose flag value to use to create new instances of [Logger].
  final bool verbose;

  /// Creates a new instance of the [LoggerFactory].
  ///
  /// If the given [writer] is `null`, an instance of
  /// the [IOLoggerWriter] is used.
  /// If the given [verbose] is `null`, the `false` value is used.
  LoggerFactory({
    LoggerWriter writer,
    bool verbose,
  })  : writer = writer ?? IOLoggerWriter(),
        verbose = verbose ?? false;

  /// Creates a new instance of the [Logger] with the given [sourceClass] value.
  Logger create(Type sourceClass) {
    return Logger(
      writer: writer,
      verbose: verbose,
      sourceClass: sourceClass,
    );
  }
}
