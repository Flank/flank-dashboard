// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';

/// A class that represents the result of the whole validation process.
/// It contains the validation results for each [ValidationTarget] participated
/// in the process.
class ValidationResult extends Equatable {
  /// A [Map] that holds the validation result values for each [ValidationTarget].
  final UnmodifiableMapView<ValidationTarget, TargetValidationResult> results;

  @override
  List<Object> get props => [results];

  /// Creates a new instance of the [ValidationResult] with the given [results].
  ///
  /// Throws an [ArgumentError] if the given [results] is `null`.
  ValidationResult(
    Map<ValidationTarget, TargetValidationResult> results,
  ) : results = UnmodifiableMapView(results) {
    ArgumentError.checkNotNull(results, 'results');
  }
}
