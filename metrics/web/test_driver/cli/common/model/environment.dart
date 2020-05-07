import 'dart:io';

/// A class that represents the environment of the process.
abstract class Environment {
  /// Maps the [Environment] to the [Map] applicable to the [Process].
  Map<String, String> toMap();
}
