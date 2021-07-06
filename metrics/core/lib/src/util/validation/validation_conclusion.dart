// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a possible conclusion of the validation process.
class ValidationConclusion extends Equatable {
  /// A name of this validation conclusion.
  final String name;

  /// A visual indicator of this conclusion.
  final String indicator;

  @override
  List<Object> get props => [name, indicator];

  /// Creates a new instance of the [ValidationConclusion] with the
  /// given parameters.
  ///
  /// Throws an [AssertionError] if the given [name] is null.
  const ValidationConclusion({
    @required this.name,
    this.indicator,
  }) : assert(name != null);
}
