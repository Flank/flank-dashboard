// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a [TargetValidationResult] for CI integrations
/// config field.
class ConfigFieldTargetValidationResult<T> extends TargetValidationResult<T> {
  /// A flag that indicates whether this is a valid target validation result.
  bool get isValid => conclusion == ConfigFieldValidationConclusion.valid;

  /// A flag that indicates whether this is an invalid target validation result.
  bool get isInvalid => conclusion == ConfigFieldValidationConclusion.invalid;

  /// A flag that indicates whether this is an unknown target validation result.
  bool get isUnknown => conclusion == ConfigFieldValidationConclusion.unknown;

  /// Creates a new instance of the [ConfigFieldTargetValidationResult] with
  /// the given parameters.
  ///
  /// The given [target] must not be `null`.
  /// The given [conclusion] must not be `null`.
  const ConfigFieldTargetValidationResult._({
    @required ValidationTarget target,
    @required ValidationConclusion conclusion,
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
  /// Represents a valid config field target validation result.
  ///
  /// The [description] defaults to an empty [String],
  /// The [details] defaults to an empty [Map].
  /// The [context] defaults to an empty [Map].
  ///
  /// The given [target] must not be `null`.
  const ConfigFieldTargetValidationResult.valid({
    @required ValidationTarget target,
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
  /// Represents an invalid config field target validation result.
  ///
  /// The [description] defaults to an empty [String],
  /// The [details] defaults to an empty [Map].
  /// The [context] defaults to an empty [Map].
  ///
  /// The given [target] must not be `null`.
  const ConfigFieldTargetValidationResult.invalid({
    @required ValidationTarget target,
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
    @required ValidationTarget target,
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
