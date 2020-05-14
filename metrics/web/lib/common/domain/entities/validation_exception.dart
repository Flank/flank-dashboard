import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// A base class for all validation exceptions.
abstract class ValidationException<T> extends Equatable implements Exception {
  /// Provides a validation error code.
  T get code;

  /// Creates the [ValidationException].
  ///
  /// If the [code] is null throws an [ArgumentError].
  ValidationException() {
    ArgumentError.checkNotNull(code);
  }

  @override
  @nonVirtual
  List<Object> get props => [code];
}
