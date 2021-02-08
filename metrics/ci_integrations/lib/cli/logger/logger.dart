// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/manager/logger_manager.dart';
import 'package:ci_integration/cli/logger/writer/logger_writer.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// A class providing methods for logging messages.
class Logger {
  /// A [Type] of the class this logger services.
  final Type sourceClass;

  /// A [LoggerWriter] this logger uses to write messages.
  final LoggerWriter _writer;

  /// A flag that determines whether to enable info logs.
  final bool _verbose;

  /// A [DateFormat] this logger uses to format timestamps of logs.
  final DateFormat _dateFormat;

  /// Creates a new instance of [Logger].
  ///
  /// All the required parameters must not be `null`.
  Logger({
    @required this.sourceClass,
    @required LoggerWriter writer,
    @required bool verbose,
  })  : _writer = writer,
        _verbose = verbose,
        _dateFormat = DateFormat.yMd().add_Hms() {
    ArgumentError.checkNotNull(sourceClass, 'sourceClass');
    ArgumentError.checkNotNull(_writer, 'writer');
    ArgumentError.checkNotNull(_verbose, 'verbose');
  }

  /// Returns a [Logger] instance for the class with the
  /// given [sourceClass] type. Calls the [LoggerManager.getLogger]
  /// method to obtain an instance of the required [Logger].
  factory Logger.forClass(Type sourceClass) {
    return LoggerManager.instance.getLogger(sourceClass);
  }

  /// Logs the given [message] using the [LoggerWriter.write]
  /// on the specified writer.
  void message(Object message) {
    final log = _processLog(message);

    _writer.write(log);
  }

  /// Logs the given [message] to the logs output
  /// if this logger is in verbose mode.
  void info(Object message) {
    if (_verbose) {
      this.message(message);
    }
  }

  /// Processes the given [log].
  ///
  /// If the [_verbose] value is `true`, applies the timestamp and
  /// [sourceClass] prefixes to the log. Otherwise, does nothing.
  Object _processLog(Object log) {
    if (_verbose) {
      final dateTimeNow = _dateFormat.format(DateTime.now());
      return '[$dateTimeNow] $sourceClass: $log';
    } else {
      return log;
    }
  }
}
