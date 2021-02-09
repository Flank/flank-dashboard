// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/field_validation_conclusion.dart';
import 'package:ci_integration/integration/interface/base/config/model/mappers/field_validation_conclusion_mapper.dart';

/// A class that represents a validation result for a single [Config]'s field.
class FieldValidationResult {
  /// A [FieldValidationConclusion] of this validation result.
  final FieldValidationConclusion conclusion;

  /// A name of the validated field.
  final String field;

  /// A [String] containing additional information about this validation result.
  final String additionalContext;

  /// Indicates whether this validation result is successful.
  bool get isSuccess => conclusion == FieldValidationConclusion.valid;

  /// Indicates whether this validation result is failure.
  bool get isFailure => conclusion == FieldValidationConclusion.invalid;

  /// Indicates whether this validation result is unknown.
  bool get isUnknown => conclusion == FieldValidationConclusion.unknown;

  /// Creates an instance of the [FieldValidationConclusion]
  /// with the given parameters.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  FieldValidationResult._(
    this.conclusion,
    this.field, [
    this.additionalContext,
  ]) {
    ArgumentError.checkNotNull(field, 'field');
  }

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [field] and [additionalContext].
  ///
  /// Represents a successful validation result.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  FieldValidationResult.success(
    String field, [
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.valid,
          field,
          additionalContext,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [field] and [additionalContext].
  ///
  /// Represents a failed validation result.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  FieldValidationResult.failure(
    String field, [
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.invalid,
          field,
          additionalContext,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [field] and [additionalContext].
  ///
  /// Represents an unknown validation result or indicates that the validation
  /// didn't run.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  FieldValidationResult.unknown(
    String field, [
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.unknown,
          field,
          additionalContext,
        );

  @override
  String toString() {
    const conclusionMapper = FieldValidationConclusionMapper();
    final conclusionValue = conclusionMapper.unmap(conclusion);

    String result = 'Validation result for the $field: $conclusionValue.';

    if (additionalContext != null) {
      result = '$result Additional context: $additionalContext';
    }

    return result;
  }
}
