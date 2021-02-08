// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
