import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/config_field_validation_conclusion.dart';

/// A class that represents a validation result for a single [Config]'s field.
class ConfigFieldValidationResult {
  /// A [ConfigFieldValidationConclusion] of this validation result.
  final ConfigFieldValidationConclusion conclusion;

  /// A name of the validated field.
  final String field;

  /// A [String] containing additional information about this validation result.
  final String additionalContext;

  /// Indicates whether this validation result is successful.
  bool get isSuccess => conclusion == ConfigFieldValidationConclusion.valid;

  /// Indicates whether this validation result is failure.
  bool get isFailure => conclusion == ConfigFieldValidationConclusion.invalid;

  /// Indicates whether this validation result is unknown.
  bool get isUnknown => conclusion == ConfigFieldValidationConclusion.unknown;

  /// Creates an instance of the [ConfigFieldValidationConclusion]
  /// with the given parameters.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  ConfigFieldValidationResult._(
    this.conclusion,
    this.field, [
    this.additionalContext,
  ]) {
    ArgumentError.checkNotNull(field, 'field');
  }

  /// Creates an instance of the [ConfigFieldValidationResult] with the given
  /// [field] and [additionalContext].
  ///
  /// Represents a successful validation result.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  ConfigFieldValidationResult.success(
    String field, [
    String additionalContext,
  ]) : this._(
          ConfigFieldValidationConclusion.valid,
          field,
          additionalContext,
        );

  /// Creates an instance of the [ConfigFieldValidationResult] with the given
  /// [field] and [additionalContext].
  ///
  /// Represents a failed validation result.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  ConfigFieldValidationResult.failure(
    String field, [
    String additionalContext,
  ]) : this._(
          ConfigFieldValidationConclusion.invalid,
          field,
          additionalContext,
        );

  /// Creates an instance of the [ConfigFieldValidationResult] with the given
  /// [field] and [additionalContext].
  ///
  /// Represents an unknown validation result or indicates that the validation
  /// didn't run.
  ///
  /// Throws an [ArgumentError] if the given [field] is `null`.
  ConfigFieldValidationResult.unknown(
    String field, [
    String additionalContext,
  ]) : this._(
          ConfigFieldValidationConclusion.unknown,
          field,
          additionalContext,
        );
}
