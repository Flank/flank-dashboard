// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_validation_target.dart';
import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class representing the Jenkins auth [TargetValidationResult]s.
class JenkinsSourceAuthValidationResult extends Equatable {
  /// A [TargetValidationResult] of the [JenkinsSourceValidationTarget.username]
  /// validation.
  final TargetValidationResult usernameValidationResult;

  /// A [TargetValidationResult] of the [JenkinsSourceValidationTarget.apiKey]
  /// validation.
  final TargetValidationResult apiKeyValidationResult;

  @override
  List<Object> get props => [usernameValidationResult, apiKeyValidationResult];

  /// Creates a new instance of the [JenkinsSourceAuthValidationResult] with
  /// the given [usernameValidationResult] and [apiKeyValidationResult].
  ///
  /// Throws an [ArgumentError] if the given [usernameValidationResult] is `null`.
  /// Throws an [ArgumentError] if the given [apiKeyValidationResult] is `null`.
  JenkinsSourceAuthValidationResult({
    this.usernameValidationResult,
    this.apiKeyValidationResult,
  }) {
    ArgumentError.checkNotNull(usernameValidationResult, 'username');
    ArgumentError.checkNotNull(apiKeyValidationResult, 'apiKey');
  }

  /// Creates a new instance of the [JenkinsSourceAuthValidationResult].
  ///
  /// The [TargetValidationResult.conclusion] for both targets is set to
  /// [ConfigFieldValidationConclusion.valid].
  /// The [TargetValidationResult.description] for both targets is set to the
  /// given [description].
  factory JenkinsSourceAuthValidationResult.success([String description]) {
    const validConclusion = ConfigFieldValidationConclusion.valid;

    final usernameValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.username,
      conclusion: validConclusion,
      description: description,
    );

    final apiKeyValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.apiKey,
      conclusion: validConclusion,
      description: description,
    );

    return JenkinsSourceAuthValidationResult(
      usernameValidationResult: usernameValidationResult,
      apiKeyValidationResult: apiKeyValidationResult,
    );
  }

  /// Creates a new instance of the [JenkinsSourceAuthValidationResult].
  ///
  /// The [TargetValidationResult.conclusion] for both targets is set to
  /// [ConfigFieldValidationConclusion.invalid].
  /// The [TargetValidationResult.description] for both targets is set to the
  /// given [description].
  factory JenkinsSourceAuthValidationResult.failure([String description]) {
    const invalidConclusion = ConfigFieldValidationConclusion.invalid;

    final usernameValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.username,
      conclusion: invalidConclusion,
      description: description,
    );

    final apiKeyValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.apiKey,
      conclusion: invalidConclusion,
      description: description,
    );

    return JenkinsSourceAuthValidationResult(
      usernameValidationResult: usernameValidationResult,
      apiKeyValidationResult: apiKeyValidationResult,
    );
  }

  /// Creates a new instance of the [JenkinsSourceAuthValidationResult].
  ///
  /// The [TargetValidationResult.conclusion] for both targets is set to
  /// [ConfigFieldValidationConclusion.unknown].
  /// The [TargetValidationResult.description] for both targets is set to the
  /// given [description].
  factory JenkinsSourceAuthValidationResult.unknown([String description]) {
    const unknownConclusion = ConfigFieldValidationConclusion.unknown;

    final usernameValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.username,
      conclusion: unknownConclusion,
      description: description,
    );

    final apiKeyValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.apiKey,
      conclusion: unknownConclusion,
      description: description,
    );

    return JenkinsSourceAuthValidationResult(
      usernameValidationResult: usernameValidationResult,
      apiKeyValidationResult: apiKeyValidationResult,
    );
  }
}
