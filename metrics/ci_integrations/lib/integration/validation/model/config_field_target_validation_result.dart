// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a [TargetValidationResult]s for config fields.
class ConfigFieldTargetValidationResult<T> extends TargetValidationResult<T> {
  /// Indicates whether this is a successful target validation result.
  bool get isSuccess => conclusion == ConfigFieldValidationConclusion.valid;

  /// Indicates whether this is a failure target validation result.
  bool get isFailure => conclusion == ConfigFieldValidationConclusion.invalid;

  /// Indicates whether this is an unknown target validation result.
  bool get isUnknown => conclusion == ConfigFieldValidationConclusion.unknown;

  /// Creates a new instance of the [ConfigFieldTargetValidationResult] with
  /// the given parameters.
  ///
  /// The given [target] must not be `null`.
  /// The given [conclusion] must not be `null`.
  const ConfigFieldTargetValidationResult._({
    ValidationTarget target,
    ValidationConclusion conclusion,
    String description,
    Map<String, dynamic> details,
    Map<String, dynamic> context,
    T data,
  }) : super(
          target: target,
          conclusion: conclusion,
          description: description,
          details: details,
          context: context,
          data: data,
        );

  /// Creates a new instance of the [ConfigFieldTargetValidationResult] with
  /// the given parameters and [ConfigFieldValidationConclusion.valid] conclusion.
  ///
  /// Represents a successful config field target validation result.
  ///
  /// The [description] defaults to an empty [String],
  /// The [details] defaults to an empty [Map].
  /// The [context] defaults to an empty [Map].
  ///
  /// The given [target] must not be `null`.
  const ConfigFieldTargetValidationResult.success({
    ValidationTarget target,
    String description = '',
    Map<String, dynamic> details = const {},
    Map<String, dynamic> context = const {},
    T data,
  }) : this._(
          target: target,
          conclusion: ConfigFieldValidationConclusion.valid,
          description: description,
          details: details,
          context: context,
          data: data,
        );

  /// Creates a new instance of the [ConfigFieldTargetValidationResult] with
  /// the given parameters and [ConfigFieldValidationConclusion.invalid] conclusion.
  ///
  /// Represents a failed config field target validation result.
  ///
  /// The [description] defaults to an empty [String],
  /// The [details] defaults to an empty [Map].
  /// The [context] defaults to an empty [Map].
  ///
  /// The given [target] must not be `null`.
  const ConfigFieldTargetValidationResult.failure({
    ValidationTarget target,
    String description = '',
    Map<String, dynamic> details = const {},
    Map<String, dynamic> context = const {},
    T data,
  }) : this._(
          target: target,
          conclusion: ConfigFieldValidationConclusion.invalid,
          description: description,
          details: details,
          context: context,
          data: data,
        );

  /// Creates a new instance of the [ConfigFieldTargetValidationResult] with
  /// the given parameters and [ConfigFieldValidationConclusion.unknown] conclusion.
  ///
  /// Represents an unknown config field target validation result or indicates
  /// that the config field validation didn't run.
  ///
  /// The [description] defaults to an empty [String],
  /// The [details] defaults to an empty [Map].
  /// The [context] defaults to an empty [Map].
  ///
  /// The given [target] must not be `null`.
  const ConfigFieldTargetValidationResult.unknown({
    ValidationTarget target,
    String description = '',
    Map<String, dynamic> details = const {},
    Map<String, dynamic> context = const {},
    T data,
  }) : this._(
          target: target,
          conclusion: ConfigFieldValidationConclusion.unknown,
          description: description,
          details: details,
          context: context,
          data: data,
        );
}
