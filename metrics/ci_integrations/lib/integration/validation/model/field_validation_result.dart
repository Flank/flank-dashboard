// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/validation/model/field_validation_conclusion.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a validation result for a single [Config]'s field.
class FieldValidationResult<T> extends Equatable {
  /// A [FieldValidationConclusion] of this field validation result.
  final FieldValidationConclusion conclusion;

  /// A [String] containing additional information about this field validation
  /// result.
  final String additionalContext;

  /// A validated data of this field validation result.
  final T data;

  /// Indicates whether this is a successful validation result.
  bool get isSuccess => conclusion == FieldValidationConclusion.valid;

  /// Indicates whether this is a failure validation result.
  bool get isFailure => conclusion == FieldValidationConclusion.invalid;

  /// Indicates whether this is an unknown validation result.
  bool get isUnknown => conclusion == FieldValidationConclusion.unknown;

  @override
  List<Object> get props => [conclusion, additionalContext, data];

  /// Creates an instance of the [FieldValidationConclusion]
  /// with the given parameters.
  const FieldValidationResult._(
    this.conclusion, [
    this.additionalContext,
    this.data,
  ]);

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext], [data], and [FieldValidationConclusion.valid]
  /// conclusion.
  ///
  /// Represents a successful field validation result.
  const FieldValidationResult.success({
    String additionalContext,
    T data,
  }) : this._(
          FieldValidationConclusion.valid,
          additionalContext,
          data,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext], [data], and [FieldValidationConclusion.invalid]
  /// conclusion.
  ///
  /// Represents a failed field validation result.
  const FieldValidationResult.failure({
    String additionalContext,
    T data,
  }) : this._(
          FieldValidationConclusion.invalid,
          additionalContext,
          data,
        );

  /// Creates an instance of the [FieldValidationResult] with the given
  /// [additionalContext], [data], and [FieldValidationConclusion.unknown]
  /// conclusion.
  ///
  /// Represents an unknown field validation result or indicates that
  /// the field validation didn't run.
  const FieldValidationResult.unknown({
    String additionalContext,
    T data,
  }) : this._(
          FieldValidationConclusion.unknown,
          additionalContext,
          data,
        );
}
