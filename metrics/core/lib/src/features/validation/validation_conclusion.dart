// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/src/domain/entities/enum.dart';

/// A class that represents a possible conclusion of the validation process.
class ValidationConclusion<T> extends Enum<T> with EquatableMixin {
  /// A name of this validation conclusion.
  final String name;

  /// A visual indicator of this conclusion.
  final String indicator;

  @override
  List<Object> get props => [value, name, indicator];

  /// Creates a new instance of the [ValidationConclusion] with the
  /// given parameters.
  ///
  /// Throws an [AssertionError] if the given [name] or [value] is null.
  const ValidationConclusion({
    @required this.name,
    @required T value,
    this.indicator,
  })  : assert(name != null),
        assert(value != null),
        super(value);
}
