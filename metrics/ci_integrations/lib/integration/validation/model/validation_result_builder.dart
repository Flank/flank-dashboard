// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config_field.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';

/// A class that provides methods for building the [ValidationResult].
class ValidationResultBuilder {
  /// A [Map] that holds the [FieldValidationResult]s of [ConfigField]s.
  final Map<ConfigField, FieldValidationResult> _results = {};

  /// Creates a new instance of the [ValidationResultBuilder]
  /// for the given [fields].
  ///
  /// A [fields] represents all [ConfigField]s of the [ValidationResult]
  /// this builder assembles.
  ///
  /// Throws an [ArgumentError] if the given [fields] is `null`.
  ValidationResultBuilder.forFields(List<ConfigField> fields) {
    ArgumentError.checkNotNull(fields);

    for (final field in fields) {
      _results[field] = null;
    }
  }

  /// Builds the [ValidationResult] using provided [FieldValidationResult]s.
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

  /// Sets the [result] for the given [field].
  ///
  /// Throws an [ArgumentError] if the provided [field] is not included in the
  /// [ValidationResult] this builder assembles.
  ///
  /// Throws a [StateError] if the provided [field] already has the
  /// [FieldValidationResult].
  void setResult(ConfigField field, FieldValidationResult result) {
    if (!_results.containsKey(field)) {
      throw ArgumentError('The provided field is not available to set.');
    }

    if (_results[field] != null) {
      throw StateError('The validation result for this field is already set.');
    }

    _results[field] = result;
  }

  /// Sets all [FieldValidationResult]s that are `null` to the given [result].
  void setEmptyResults(FieldValidationResult result) {
    for (final key in _results.keys) {
      _results[key] ??= result;
    }
  }
}
