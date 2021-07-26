// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config_field.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A class responsible for validating the [GithubActionsSourceConfig].
class GithubActionsSourceValidator
    implements ConfigValidatorStub<GithubActionsSourceConfig> {
  @override
  final GithubActionsSourceValidationDelegate validationDelegate;

  @override
  final ValidationResultBuilder validationResultBuilder;

  /// Creates a new instance of the [GithubActionsSourceValidator]
  /// with the given [validationDelegate] and [validationResultBuilder].
  ///
  /// Throws an [ArgumentError] if the given [validationDelegate]
  /// or [validationResultBuilder] is `null`.
  GithubActionsSourceValidator(
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
  Future<ValidationResult> validate(GithubActionsSourceConfig config) async {
    final accessToken = config.accessToken;

    if (accessToken == null) {
      _setUnknownFieldValidationResult(
        GithubActionsSourceConfigField.accessToken,
        GithubActionsStrings.tokenNotSpecified,
      );

      return _finalizeValidationResult(
        GithubActionsStrings.tokenNotSpecifiedInterruptReason,
      );
    }

    final auth = BearerAuthorization(accessToken);

    final authValidationResult = await validationDelegate.validateAuth(auth);

    validationResultBuilder.setResult(
      GithubActionsSourceConfigField.accessToken,
      authValidationResult,
    );

    if (authValidationResult.isFailure) {
      return _finalizeValidationResult(
        GithubActionsStrings.tokenInvalidInterruptReason,
      );
    }

    final repositoryOwner = config.repositoryOwner;
    final repositoryOwnerValidationResult =
        await validationDelegate.validateRepositoryOwner(repositoryOwner);

    validationResultBuilder.setResult(
      GithubActionsSourceConfigField.repositoryOwner,
      repositoryOwnerValidationResult,
    );

    if (repositoryOwnerValidationResult.isFailure) {
      return _finalizeValidationResult(
        GithubActionsStrings.repositoryOwnerInvalidInterruptReason,
      );
    }

    final repositoryName = config.repositoryName;
    final repositoryNameValidationResult =
        await validationDelegate.validateRepositoryName(
      repositoryName: repositoryName,
      repositoryOwner: repositoryOwner,
    );

    validationResultBuilder.setResult(
      GithubActionsSourceConfigField.repositoryName,
      repositoryNameValidationResult,
    );

    if (repositoryNameValidationResult.isFailure) {
      return _finalizeValidationResult(
        GithubActionsStrings.repositoryNameInvalidInterruptReason,
      );
    }

    final workflowId = config.workflowIdentifier;
    final workflowIdValidationResult =
        await validationDelegate.validateWorkflowId(
      workflowId,
    );

    validationResultBuilder.setResult(
      GithubActionsSourceConfigField.workflowIdentifier,
      workflowIdValidationResult,
    );

    if (workflowIdValidationResult.isFailure) {
      return _finalizeValidationResult(
        GithubActionsStrings.workflowIdInvalidInterruptReason,
      );
    }

    final jobName = config.jobName;
    final jobNameValidationResult = await validationDelegate.validateJobName(
      workflowId: workflowId,
      jobName: jobName,
    );

    validationResultBuilder.setResult(
      GithubActionsSourceConfigField.jobName,
      jobNameValidationResult,
    );

    final coverageArtifact = config.coverageArtifactName;
    final coverageArtifactValidationResult =
        await validationDelegate.validateCoverageArtifactName(
      workflowId: workflowId,
      coverageArtifactName: coverageArtifact,
    );

    validationResultBuilder.setResult(
      GithubActionsSourceConfigField.coverageArtifactName,
      coverageArtifactValidationResult,
    );

    return validationResultBuilder.build();
  }

  /// Sets the [FieldValidationResult.unknown] with the given
  /// [additionalContext] to the given [field] using
  /// the [validationResultBuilder].
  void _setUnknownFieldValidationResult(
    GithubActionsSourceConfigField field,
    String additionalContext,
  ) {
    final validationResult = FieldValidationResult.unknown(
      additionalContext: additionalContext,
    );

    validationResultBuilder.setResult(field, validationResult);
  }

  /// Sets the empty results of the [validationResultBuilder] using
  /// the given [interruptReason] and builds the [ValidationResult]
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
