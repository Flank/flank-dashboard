// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a single entity under the validation.
/// More precisely, this describes the value to be validated during the
/// validation process.
class ValidationTarget extends Equatable {
  /// A name of this validation target.
  final String name;

  /// A description of this validation target.
  final String description;

  @override
  List<Object> get props => [name, description];

  /// Creates a new instance of the [ValidationTarget] with the given parameters.
  ///
  /// The given [name] must not be `null`.
  const ValidationTarget({
    @required this.name,
    this.description,
  }) : assert(name != null);
}
