// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config_field.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';

/// A class responsible for validating the [GithubActionsSourceConfig].
class GithubActionsSourceValidator
    extends ConfigValidator<GithubActionsSourceConfig> {
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

    final authInteraction = await validationDelegate.validateAuth(auth);

    _processInteraction(
      interaction: authInteraction,
      field: GithubActionsSourceConfigField.accessToken,
    );

    if (authInteraction.isError) {
      return _finalizeValidationResult(
        GithubActionsStrings.tokenInvalidInterruptReason,
      );
    }

    final repositoryOwner = config.repositoryOwner;
    final repositoryOwnerInteraction =
        await validationDelegate.validateRepositoryOwner(repositoryOwner);

    _processInteraction(
      interaction: repositoryOwnerInteraction,
      field: GithubActionsSourceConfigField.repositoryOwner,
    );

    if (repositoryOwnerInteraction.isError) {
      return _finalizeValidationResult(
        GithubActionsStrings.repositoryOwnerInvalidInterruptReason,
      );
    }

    final repositoryName = config.repositoryName;
    final repositoryNameInteraction =
        await validationDelegate.validateRepositoryName(
      repositoryName: repositoryName,
      repositoryOwner: repositoryOwner,
    );

    _processInteraction(
      interaction: repositoryNameInteraction,
      field: GithubActionsSourceConfigField.repositoryName,
    );

    if (repositoryNameInteraction.isError) {
      return _finalizeValidationResult(
        GithubActionsStrings.repositoryNameInvalidInterruptReason,
      );
    }

    final workflowId = config.workflowIdentifier;
    final workflowIdInteraction = await validationDelegate.validateWorkflowId(
      workflowId,
    );

    _processInteraction(
      interaction: workflowIdInteraction,
      field: GithubActionsSourceConfigField.workflowIdentifier,
    );

    if (workflowIdInteraction.isError) {
      return _finalizeValidationResult(
        GithubActionsStrings.workflowIdInvalidInterruptReason,
      );
    }

    final jobName = config.jobName;
    final jobNameInteraction = await validationDelegate.validateJobName(
      workflowId: workflowId,
      jobName: jobName,
    );

    _processInteractionWithResult(
      interaction: jobNameInteraction,
      field: GithubActionsSourceConfigField.jobName,
    );

    final coverageArtifact = config.coverageArtifactName;
    final artifactInteraction =
        await validationDelegate.validateCoverageArtifactName(
      workflowId: workflowId,
      coverageArtifactName: coverageArtifact,
    );

    _processInteractionWithResult(
      interaction: artifactInteraction,
      field: GithubActionsSourceConfigField.coverageArtifactName,
    );

    return validationResultBuilder.build();
  }

  /// Processes the given [interaction] or sets the [field] validation result
  /// to [FieldValidationResult.unknown].
  void _processInteractionWithResult({
    @required InteractionResult interaction,
    @required GithubActionsSourceConfigField field,
  }) {
    if (interaction.isSuccess && interaction.result == null) {
      _setUnknownFieldValidationResult(
        field,
        interaction.message,
      );
    } else {
      _processInteraction(
        interaction: interaction,
        field: field,
      );
    }
  }

  /// Processes the given [interaction].
  ///
  /// Maps the given [interaction] to a [FieldValidationResult] and
  /// sets the [field] validation result in [validationResultBuilder].
  void _processInteraction({
    @required InteractionResult interaction,
    @required GithubActionsSourceConfigField field,
  }) {
    final fieldValidationResult = _mapInteractionToFieldValidationResult(
      interaction,
    );

    validationResultBuilder.setResult(field, fieldValidationResult);
  }

  /// Maps the given [interaction] to a [FieldValidationResult].
  ///
  /// Returns [FieldValidationResult.failure] if
  /// the [interaction.isError] is `true`.
  ///
  /// Otherwise, returns [FieldValidationResult.success].
  FieldValidationResult _mapInteractionToFieldValidationResult(
    InteractionResult interaction,
  ) {
    final additionalContext = interaction.message;

    if (interaction.isError) {
      return FieldValidationResult.failure(additionalContext);
    }

    return FieldValidationResult.success(additionalContext);
  }

  /// Sets the [FieldValidationResult.unknown] with the given
  /// [additionalContext] to the given [field] using
  /// the [validationResultBuilder].
  void _setUnknownFieldValidationResult(
    GithubActionsSourceConfigField field,
    String additionalContext,
  ) {
    final validationResult = FieldValidationResult.unknown(additionalContext);

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
    final emptyFieldResult = FieldValidationResult.unknown(interruptReason);

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }
}
