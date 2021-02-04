// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/cli/logger/factory/logger_factory.dart';

/// A class that manages loggers of different classes by their type and
/// provides loggers for instances of these classes.
class LoggerManager {
  /// A default [LoggerFactory] instance to use for this manager.
  static final LoggerFactory _defaultLoggerFactory = LoggerFactory();

  /// A [LoggerManager] instance to follow the Singleton pattern.
  static final LoggerManager _instance = LoggerManager._();

  /// A [LoggerFactory] this manager uses to create new instances of [Logger].
  static LoggerFactory _loggerFactory = _defaultLoggerFactory;

  /// Returns the current instance of the [LoggerManager].
  static LoggerManager get instance => _instance;

  /// A [Map] that holds [Logger] instances for a specific class [Type]s.
  final Map<Type, Logger> _loggers;

  /// Creates a new instance of the [LoggerManager] with an empty [_loggers] map.
  LoggerManager._() : _loggers = {};

  /// Sets the current [LoggerFactory] to the given [loggerFactory].
  ///
  /// If the given [loggerFactory] is `null`, uses the [LoggerFactory] instance
  /// with the default parameters.
  ///
  /// Changing logger factory does not affect the existing [Logger] instances
  /// created using the previous factory.
  static void setLoggerFactory(LoggerFactory loggerFactory) {
    _loggerFactory = loggerFactory ?? _defaultLoggerFactory;
  }

  /// Returns a [Logger] for the given [sourceClass] type.
  ///
  /// If a logger for the given [sourceClass] exists,
  /// returns the existing instance. Otherwise, returns a new instance
  /// created by calling the [LoggerFactory.create] on the current factory.
  Logger getLogger(Type sourceClass) {
    final logger = _loggers[sourceClass];

    if (logger == null) {
      final newLogger = _loggerFactory.create(sourceClass);
      _loggers[sourceClass] = newLogger;

      return newLogger;
    } else {
      return logger;
    }
  }

  /// Resets loggers created with this manager.
  ///
  /// Clears the map of loggers for all classes. This means that for all
  /// classes the [getLogger] method creates new loggers using
  /// the current [LoggerFactory].
  void reset() {
    _loggers.clear();
  }
}
