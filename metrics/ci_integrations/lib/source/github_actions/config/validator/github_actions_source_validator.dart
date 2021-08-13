// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/config_field_target_validation_result.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_validation_target.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class responsible for validating the [GithubActionsSourceConfig].
class GithubActionsSourceValidator
    implements ConfigValidator<GithubActionsSourceConfig> {
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
        GithubActionsSourceValidationTarget.accessToken,
        GithubActionsStrings.tokenNotSpecified,
      );

      return _finalizeValidationResult(
        GithubActionsSourceValidationTarget.accessToken,
        GithubActionsStrings.tokenNotSpecifiedInterruptReason,
      );
    }

    final auth = BearerAuthorization(accessToken);

    final authValidationResult = await validationDelegate.validateAuth(auth);

    validationResultBuilder.setResult(authValidationResult);

    if (authValidationResult.isInvalid) {
      return _finalizeValidationResult(
        GithubActionsSourceValidationTarget.accessToken,
        GithubActionsStrings.tokenInvalidInterruptReason,
      );
    }

    final repositoryOwner = config.repositoryOwner;
    final repositoryOwnerValidationResult =
        await validationDelegate.validateRepositoryOwner(repositoryOwner);

    validationResultBuilder.setResult(repositoryOwnerValidationResult);

    if (repositoryOwnerValidationResult.isInvalid) {
      return _finalizeValidationResult(
        GithubActionsSourceValidationTarget.repositoryOwner,
        GithubActionsStrings.repositoryOwnerInvalidInterruptReason,
      );
    }

    final repositoryName = config.repositoryName;
    final repositoryNameValidationResult =
        await validationDelegate.validateRepositoryName(
      repositoryName: repositoryName,
      repositoryOwner: repositoryOwner,
    );

    validationResultBuilder.setResult(repositoryNameValidationResult);

    if (repositoryNameValidationResult.isInvalid) {
      return _finalizeValidationResult(
        GithubActionsSourceValidationTarget.repositoryName,
        GithubActionsStrings.repositoryNameInvalidInterruptReason,
      );
    }

    final workflowId = config.workflowIdentifier;
    final workflowIdValidationResult =
        await validationDelegate.validateWorkflowId(
      workflowId,
    );

    validationResultBuilder.setResult(workflowIdValidationResult);

    if (workflowIdValidationResult.isInvalid) {
      return _finalizeValidationResult(
        GithubActionsSourceValidationTarget.workflowIdentifier,
        GithubActionsStrings.workflowIdInvalidInterruptReason,
      );
    }

    final jobName = config.jobName;
    final jobNameValidationResult = await validationDelegate.validateJobName(
      workflowId: workflowId,
      jobName: jobName,
    );

    validationResultBuilder.setResult(jobNameValidationResult);

    final coverageArtifact = config.coverageArtifactName;
    final coverageArtifactValidationResult =
        await validationDelegate.validateCoverageArtifactName(
      workflowId: workflowId,
      coverageArtifactName: coverageArtifact,
    );

    validationResultBuilder.setResult(coverageArtifactValidationResult);

    return validationResultBuilder.build();
  }

  /// Sets the [ConfigFieldTargetValidationResult.unknown] with the given
  /// [description] to the given [target] using
  /// the [validationResultBuilder].
  void _setUnknownFieldValidationResult(
    ValidationTarget target,
    String description,
  ) {
    final validationResult = ConfigFieldTargetValidationResult.unknown(
      target: target,
      description: description,
    );

    validationResultBuilder.setResult(validationResult);
  }

  /// Builds the [ValidationResult] using the [validationResultBuilder], where
  /// the [TargetValidationResult]s of empty fields contain the given [target]
  /// and [interruptReason].
  ValidationResult _finalizeValidationResult(
    ValidationTarget target,
    String interruptReason,
  ) {
    _setEmptyTargets(target, interruptReason);

    return validationResultBuilder.build();
  }

  /// Sets empty results of the [validationResultBuilder] to the
  /// [ConfigFieldTargetValidationResult.unknown].
  void _setEmptyTargets(ValidationTarget target, String interruptReason) {
    final emptyFieldResult = ConfigFieldTargetValidationResult.unknown(
      target: target,
      description: interruptReason,
    );

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }
}
