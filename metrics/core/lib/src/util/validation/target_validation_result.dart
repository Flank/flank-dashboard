// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/src/util/validation/validation_conclusion.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';

/// A class that represents a validation result for a single [ValidationTarget].
class TargetValidationResult<T> extends Equatable {
  /// A validated data of this target validation result.
  final T data;

  /// A [ValidationTarget] of this target validation result.
  final ValidationTarget target;

  /// A [ValidationConclusion] of this target validation result.
  final ValidationConclusion conclusion;

  /// A [String] containing short description of this target validation
  /// result.
  final String description;

  /// A [Map] containing additional details of this target validation result.
  final Map<String, dynamic> details;

  /// A [Map] containing context of the validation result's process.
  final Map<String, dynamic> context;

  @override
  List<Object> get props => [
        data,
        target,
        conclusion,
        description,
        details,
        context,
      ];

  /// Creates a new instance of the [TargetValidationResult] with the given
  /// parameters.
  ///
  /// The [description] defaults to an empty [String],
  /// The [details] defaults to an empty [Map].
  /// The [context] defaults to an empty [Map].
  ///
  /// The given [target] must not be `null`.
  /// The given [conclusion] must not be `null`.
  const TargetValidationResult({
    @required this.target,
    @required this.conclusion,
    this.description = '',
    this.details = const {},
    this.context = const {},
    this.data,
  })  : assert(target != null),
        assert(conclusion != null);
}
