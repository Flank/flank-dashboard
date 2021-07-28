// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_validation_target.dart';
import 'package:ci_integration/source/jenkins/config/validation_delegate/jenkins_source_validation_delegate.dart';
import 'package:ci_integration/source/jenkins/strings/jenkins_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class responsible for validating the [JenkinsSourceConfig].
class JenkinsSourceValidator implements ConfigValidator<JenkinsSourceConfig> {
  @override
  final JenkinsSourceValidationDelegate validationDelegate;

  @override
  final ValidationResultBuilder validationResultBuilder;

  /// Creates a new instance of the [JenkinsSourceValidator] with the given
  /// [validationDelegate] and [validationResultBuilder].
  ///
  /// Throws an [ArgumentError] if the given [validationDelegate] or
  /// [validationResultBuilder] is `null`.
  JenkinsSourceValidator(
    this.validationDelegate,
    this.validationResultBuilder,
  ) {
    ArgumentError.checkNotNull(validationDelegate, 'validationDelegate');
    ArgumentError.checkNotNull(
      validationResultBuilder,
      'validationResultBuilder',
    );
  }

  @override
  Future<ValidationResult> validate(JenkinsSourceConfig config) async {
    final jenkinsUrl = config.url;
    final jenkinsUrlValidationResult =
        await validationDelegate.validateJenkinsUrl(jenkinsUrl);

    validationResultBuilder.setResult(
      JenkinsSourceValidationTarget.url,
      jenkinsUrlValidationResult,
    );

    if (jenkinsUrlValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        JenkinsSourceValidationTarget.url,
        JenkinsStrings.jenkinsUrlInvalidInterruptReason,
      );
    }

    final username = config.username;
    final apiKey = config.apiKey;

    if (username == null || apiKey == null) {
      final interruptReason = _buildMissingCredentialsInterruptReason(
        username,
        apiKey,
      );

      return _finalizeValidationResult(
        JenkinsSourceValidationTarget.apiKey,
        interruptReason,
      );
    }

    final auth = BasicAuthorization(username, apiKey);
    final authValidationResult = await validationDelegate.validateAuth(auth);
    final usernameValidationResult =
        authValidationResult.usernameValidationResult;
    final apiKeyValidationResult = authValidationResult.apiKeyValidationResult;

    validationResultBuilder.setResult(
      JenkinsSourceValidationTarget.username,
      usernameValidationResult,
    );

    validationResultBuilder.setResult(
      JenkinsSourceValidationTarget.apiKey,
      apiKeyValidationResult,
    );

    if (apiKeyValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        JenkinsSourceValidationTarget.apiKey,
        JenkinsStrings.authInvalidInterruptReason,
      );
    }

    final jobName = config.jobName;
    final jobNameValidationResult =
        await validationDelegate.validateJobName(jobName);

    validationResultBuilder.setResult(
      JenkinsSourceValidationTarget.jobName,
      jobNameValidationResult,
    );

    return validationResultBuilder.build();
  }

  /// Builds an interrupt reason [String] specifying which auth credentials are
  /// missing.
  String _buildMissingCredentialsInterruptReason(
    String username,
    String apiKey,
  ) {
    final missingCredentials = <String>[];

    if (username == null) {
      missingCredentials.add(JenkinsSourceValidationTarget.username.name);
    }

    if (apiKey == null) {
      missingCredentials.add(JenkinsSourceValidationTarget.apiKey.name);
    }

    return JenkinsStrings.missingAuthCredentialsInterruptReason(
      missingCredentials.join(', '),
    );
  }

  /// Builds the [ValidationResult] using the [validationResultBuilder], where
  /// the [TargetValidationResult]s of empty fields contain the given [target]
  /// and [interruptReason].
  ValidationResult _finalizeValidationResult(
    ValidationTarget target,
    String interruptReason,
  ) {
    _setEmptyFields(target, interruptReason);

    return validationResultBuilder.build();
  }

  /// Sets empty results of the [validationResultBuilder] to the
  /// [TargetValidationResult] with the given [target] and [interruptReason],
  /// and [ConfigFieldValidationConclusion.unknown] as a
  /// [TargetValidationResult.conclusion].
  void _setEmptyFields(ValidationTarget target, String interruptReason) {
    final emptyFieldResult = TargetValidationResult(
      target: target,
      conclusion: ConfigFieldValidationConclusion.unknown,
      description: interruptReason,
    );

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }
}
