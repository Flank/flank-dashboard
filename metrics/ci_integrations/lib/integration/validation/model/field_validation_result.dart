// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/validation/model/field_validation_conclusion.dart';
import 'package:ci_integration/integration/validation/model/mappers/field_validation_conclusion_mapper.dart';

/// A class that represents a validation result for a single [Config]'s field.
class FieldValidationResult {
  /// A [FieldValidationConclusion] of this validation result.
  final FieldValidationConclusion conclusion;

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
  const FieldValidationResult._(
    this.conclusion, [
    this.additionalContext,
  ]);

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext].
  ///
  /// Represents a successful validation result.
  FieldValidationResult.success([
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.valid,
          additionalContext,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext].
  ///
  /// Represents a failed validation result.
  FieldValidationResult.failure([
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.invalid,
          additionalContext,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext].
  ///
  /// Represents an unknown validation result or indicates that the validation
  /// didn't run.
  FieldValidationResult.unknown([
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.unknown,
          additionalContext,
        );

  @override
  String toString() {
    const conclusionMapper = FieldValidationConclusionMapper();

    final conclusionValue = conclusionMapper.unmap(conclusion);

    String message = '$conclusionValue.';

    if (additionalContext != null) {
      message = '$message Additional context: $additionalContext';
    }

    return message;
  }
}
