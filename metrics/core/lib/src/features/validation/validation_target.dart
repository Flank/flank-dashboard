// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/src/domain/entities/enum.dart';

/// A class that represents a single entity used in the validation process.
class ValidationTarget<T> extends Enum<T> with EquatableMixin {
  /// A name of this validation target.
  final String name;

  /// A description of this validation target.
  final String description;

  @override
  List<Object> get props => [value, name, description];

  /// Creates a new instance of the [ValidationTarget] with the given parameters.
  ///
  /// Throws an [AssertionError] if the given [name] or [value] is null.
  const ValidationTarget({
    @required this.name,
    @required T value,
    this.description,
  })  : assert(name != null),
        assert(value != null),
        super(value);
}
