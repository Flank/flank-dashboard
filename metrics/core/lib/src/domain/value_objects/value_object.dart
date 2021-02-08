// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A base class for all value objects.
abstract class ValueObject<T> extends Equatable {
  /// Provides a value of this object.
  T get value;

  @override
  List<Object> get props => [value];
}
