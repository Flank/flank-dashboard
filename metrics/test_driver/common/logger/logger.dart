import 'dart:io';

/// Prints the outputs to the console.
class Logger {
  static bool _quiet = false;
  static Directory _logsDirectory;

  static Directory get logsDirectory => _logsDirectory;

  /// Configures [Logger].
  ///
  /// [quiet] defines whether print any logs to console or not.
  /// [logsDirectory] defines the directory to store logs.
  static void setup({bool quiet, Directory logsDirectory}) {
    _quiet = quiet;
    _logsDirectory = logsDirectory;
  }

  /// Print the [value] as the default console output.
  static void log(String value) {
    if (_quiet) return;

    stdout.writeln(value);
  }

  /// Prints the [value] as the error console output.
  static void error(String value) {
    if (_quiet) return;

    stderr.writeln(value);
  }

  /// Appends the [file] with the [value].
  static void logToFile(String value, File file) {
    file.writeAsStringSync(value, mode: FileMode.append);
  }
}
