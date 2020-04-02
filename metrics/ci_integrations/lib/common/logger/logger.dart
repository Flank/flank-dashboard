import 'dart:io';

/// A class providing methods for logging messages and errors for CLI tool.
class Logger {
  const Logger();

  /// Prints the given [error] to the [stderr].
  void printError(Object error) => stderr.writeln(error);

  /// Prints the given [message] to the [stdout].
  void printMessage(Object message) => stdout.writeln(message);
}
