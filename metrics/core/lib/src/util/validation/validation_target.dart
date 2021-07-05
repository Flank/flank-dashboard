// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a single entity used in the validation process.
class ValidationTarget<T> extends Equatable {
  /// A name of this validation target.
  final String name;

  /// A description of this validation target.
  final String description;

  @override
  List<Object> get props => [name, description];

  /// Creates a new instance of the [ValidationTarget] with the given parameters.
  ///
  /// Throws an [AssertionError] if the given [name] is null.
  const ValidationTarget({
    @required this.name,
    this.description,
  }) : assert(name != null);
}
