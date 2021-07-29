// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';

/// A class that provides methods for building the [ValidationResult].
class ValidationResultBuilder {
  /// A [Map] that holds the [TargetValidationResult]s of [ValidationTarget]s.
  final Map<ValidationTarget, TargetValidationResult> _results = {};

  /// Creates a new instance of the [ValidationResultBuilder]
  /// for the given [targets].
  ///
  /// A [targets] list represents all [ValidationTarget]s of the [ValidationResult]
  /// this builder assembles.
  ///
  /// Throws an [ArgumentError] if the given [targets] is `null`.
  ValidationResultBuilder.forTargets(List<ValidationTarget> targets) {
    ArgumentError.checkNotNull(targets);

    for (final target in targets) {
      _results[target] = null;
    }
  }

  /// Sets the [result] for the corresponding [TargetValidationResult.target].
  ///
  /// Throws an [ArgumentError] if the [TargetValidationResult.target] of
  /// the given [result] is not included in the [ValidationResult]
  /// this builder assembles.
  ///
  /// Throws a [StateError] if the [TargetValidationResult.target] of
  /// the given [result] already has the [TargetValidationResult].
  void setResult(TargetValidationResult result) {
    final target = result.target;

    if (!_results.containsKey(target)) {
      throw ArgumentError('The provided target is not available to set.');
    }

    if (_results[target] != null) {
      throw StateError('The validation result for this target is already set.');
    }

    _results[target] = result;
  }

  /// Sets all [TargetValidationResult]s that are `null` to the given [result].
  void setEmptyResults(TargetValidationResult result) {
    for (final key in _results.keys) {
      _results[key] ??= result;
    }
  }

  /// Builds the [ValidationResult] using [TargetValidationResult]s.
  ///
  /// Throws a [StateError] if there are any targets with no validation results.
  ValidationResult build() {
    if (_results.containsValue(null)) {
      throw StateError(
        'Cannot create a validation result, since some targets do not have validation result.',
      );
    }

    return ValidationResult(_results);
  }
}
