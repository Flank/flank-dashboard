// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

/// Logger used to log messages from different parts of the application
/// to the appropriate output stream (std, err) or file.
class Logger {
  static bool _quiet = false;
  static Directory _logsDirectory;

  static Directory get logsDirectory => _logsDirectory;

  /// Configures [Logger].
  ///
  /// [quiet] quiet mode, if true - all log messages will be ignored.
  /// [logsDirectory] defines the directory to store logs.
  static void setup({bool quiet, Directory logsDirectory}) {
    _quiet = quiet;
    _logsDirectory = logsDirectory;
  }

  /// Print the [value] as to the [stdout].
  static void log(String value) {
    if (_quiet) return;

    stdout.writeln(value);
  }

  /// Prints the [value] to the [stderr].
  static void error(String value) {
    if (_quiet) return;

    stderr.writeln(value);
  }

  /// Appends the [file] with the [value].
  static void logToFile(String value, File file) {
    if (_quiet) return;

    file.writeAsStringSync(value, mode: FileMode.append);
  }
}
