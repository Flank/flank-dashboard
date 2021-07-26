// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config_field.dart';
import 'package:ci_integration/source/jenkins/config/validation_delegate/jenkins_source_validation_delegate.dart';
import 'package:ci_integration/source/jenkins/strings/jenkins_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A class responsible for validating the [JenkinsSourceConfig].
class JenkinsSourceValidator
    implements ConfigValidatorStub<JenkinsSourceConfig> {
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
      JenkinsSourceConfigField.url,
      jenkinsUrlValidationResult,
    );

    if (jenkinsUrlValidationResult.isFailure) {
      return _finalizeValidationResult(
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

      return _finalizeValidationResult(interruptReason);
    }

    final auth = BasicAuthorization(username, apiKey);
    final authValidationResult = await validationDelegate.validateAuth(
      auth,
    );

    validationResultBuilder.setResult(
      JenkinsSourceConfigField.username,
      authValidationResult,
    );

    validationResultBuilder.setResult(
      JenkinsSourceConfigField.apiKey,
      authValidationResult,
    );

    if (authValidationResult.isFailure) {
      return _finalizeValidationResult(
        JenkinsStrings.authInvalidInterruptReason,
      );
    }

    final jobName = config.jobName;
    final jobNameValidationResult =
        await validationDelegate.validateJobName(jobName);

    validationResultBuilder.setResult(
      JenkinsSourceConfigField.jobName,
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
      missingCredentials.add(JenkinsSourceConfigField.username.value);
    }

    if (apiKey == null) {
      missingCredentials.add(JenkinsSourceConfigField.apiKey.value);
    }

    return JenkinsStrings.missingAuthCredentialsInterruptReason(
      missingCredentials.join(', '),
    );
  }

  /// Sets the empty results of the [validationResultBuilder] using the given
  /// [interruptReason] and builds the [ValidationResult]
  /// using the [validationResultBuilder].
  ValidationResult _finalizeValidationResult(String interruptReason) {
    _setEmptyFields(interruptReason);

    return validationResultBuilder.build();
  }

  /// Sets empty results of the [validationResultBuilder] to the
  /// [FieldValidationResult.unknown] with the given [interruptReason] as
  /// a [FieldValidationResult.additionalContext].
  void _setEmptyFields(String interruptReason) {
    final emptyFieldResult = FieldValidationResult.unknown(
      additionalContext: interruptReason,
    );

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }
}
