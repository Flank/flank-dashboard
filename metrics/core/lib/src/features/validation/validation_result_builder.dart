// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/features/validation/target_validation_result.dart';
import 'package:metrics_core/src/features/validation/validation_result.dart';
import 'package:metrics_core/src/features/validation/validation_target.dart';

/// A class that provides methods for building the [ValidationResult].
class ValidationResultBuilder<T extends ValidationTarget> {
  /// A [Map] that holds the [TargetValidationResult]s of [ValidationTarget]s.
  final Map<T, TargetValidationResult> _results = {};

  /// Creates a new instance of the [ValidationResultBuilder]
  /// for the given [targets].
  ///
  /// A [targets] represents all [ValidationTarget]s of the [ValidationResult]
  /// this builder assembles.
  ///
  /// Throws an [ArgumentError] if the given [targets] is `null`.
  ValidationResultBuilder.forItems(List<T> targets) {
    ArgumentError.checkNotNull(targets);

    for (final target in targets) {
      _results[target] = null;
    }
  }

  /// Sets the [result] for the given [target].
  ///
  /// Throws an [ArgumentError] if the provided [target] is not included in the
  /// [ValidationResult] this builder assembles.
  ///
  /// Throws a [StateError] if the provided [target] already has the
  /// [TargetValidationResult].
  void setResult(T target, TargetValidationResult result) {
    if (!_results.containsKey(target)) {
      throw ArgumentError('The provided field is not available to set.');
    }

    if (_results[target] != null) {
      throw StateError('The validation result for this field is already set.');
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
  /// Throws a [StateError] if there are any fields with no validation results.
  ValidationResult build() {
    if (_results.containsValue(null)) {
      throw StateError(
        'Cannot create a validation result, since some fields do not have validation result.',
      );
    }

    return ValidationResult(_results);
  }
}
