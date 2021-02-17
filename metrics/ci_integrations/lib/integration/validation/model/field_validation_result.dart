// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/validation/model/field_validation_conclusion.dart';

/// A class that represents a validation result for a single [Config]'s field.
class FieldValidationResult {
  /// A [FieldValidationConclusion] of this field validation result.
  final FieldValidationConclusion conclusion;

  /// A [String] containing additional information about this field validation
  /// result.
  final String additionalContext;

  /// Indicates whether this field validation result is successful.
  bool get isSuccess => conclusion == FieldValidationConclusion.valid;

  /// Indicates whether this field validation result is failure.
  bool get isFailure => conclusion == FieldValidationConclusion.invalid;

  /// Indicates whether this field validation result is unknown.
  bool get isUnknown => conclusion == FieldValidationConclusion.unknown;

  /// Creates an instance of the [FieldValidationConclusion]
  /// with the given parameters.
  const FieldValidationResult._(
    this.conclusion, [
    this.additionalContext,
  ]);

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext] and [FieldValidationConclusion.valid] conclusion.
  ///
  /// Represents a successful field validation result.
  FieldValidationResult.success([
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.valid,
          additionalContext,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext] and [FieldValidationConclusion.invalid] conclusion.
  ///
  /// Represents a failed field validation result.
  FieldValidationResult.failure([
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.invalid,
          additionalContext,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext] and [FieldValidationConclusion.unknown] conclusion.
  ///
  /// Represents an unknown field validation result or indicates that
  /// the field validation didn't run.
  FieldValidationResult.unknown([
    String additionalContext,
  ]) : this._(
          FieldValidationConclusion.unknown,
          additionalContext,
        );
}
