/*
 * Use of this source code is governed by the Apache License, Version 2.0
 * that can be found in the LICENSE file.
 */

/*
 * Use of this source code is governed by the Apache License, Version 2.0
 * that can be found in the LICENSE file.
 */

/*
 * Use of this source code is governed by the Apache License, Version 2.0
 * that can be found in the LICENSE file.
 */

// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config_field.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';

/// A class responsible for validating the [BuildkiteSourceConfig].
class BuildkiteSourceValidator extends ConfigValidator<BuildkiteSourceConfig> {
  @override
  final BuildkiteSourceValidationDelegate validationDelegate;

  @override
  final ValidationResultBuilder validationResultBuilder;

  /// Creates a new instance of the [BuildkiteSourceValidator] with the
  /// given [validationDelegate] and [validationResultBuilder].
  ///
  /// Throws an [ArgumentError] if the given [validationDelegate]
  /// or [validationResultBuilder] is `null`.
  BuildkiteSourceValidator(
    this.validationDelegate,
    this.validationResultBuilder,
  ) {
    ArgumentError.checkNotNull(validationDelegate);
    ArgumentError.checkNotNull(validationResultBuilder);
  }

  @override
  Future<ValidationResult> validate(
    BuildkiteSourceConfig config,
  ) async {
    final accessToken = config.accessToken;
    final auth = BearerAuthorization(accessToken);

    final tokenInteraction = await validationDelegate.validateAuth(auth);

    _processInteraction(
      interaction: tokenInteraction,
      field: BuildkiteSourceConfigField.accessToken,
    );

    if (tokenInteraction.isError) {
      const interruptReason = BuildkiteStrings.tokenInvalidInterruptReason;
      final emptyFieldResult = FieldValidationResult.unknown(interruptReason);

      validationResultBuilder.setEmptyResults(emptyFieldResult);

      return validationResultBuilder.build();
    }

    final token = tokenInteraction.result;

    if (!_canValidateOrganization(token)) {
      final organizationValidationResult = FieldValidationResult.unknown(
        BuildkiteStrings.noScopesToValidateOrganization,
      );

      validationResultBuilder.setResult(
        BuildkiteSourceConfigField.organizationSlug,
        organizationValidationResult,
      );

      _setEmptyFields(
          BuildkiteStrings.organizationCantBeValidatedInterruptReason);

      return validationResultBuilder.build();
    }

    final organizationSlug = config.organizationSlug;
    final organizationInteraction =
        await validationDelegate.validateOrganizationSlug(organizationSlug);

    _processInteraction(
      interaction: organizationInteraction,
      field: BuildkiteSourceConfigField.organizationSlug,
    );

    if (organizationInteraction.isError) {
      _setEmptyFields(BuildkiteStrings.organizationInvalidInterruptReason);

      return validationResultBuilder.build();
    }

    if (!_canValidatePipeline(token)) {
      final pipelineValidationResult = FieldValidationResult.unknown(
        BuildkiteStrings.noScopesToValidatePipeline,
      );

      validationResultBuilder.setResult(
        BuildkiteSourceConfigField.pipelineSlug,
        pipelineValidationResult,
      );

      return validationResultBuilder.build();
    }

    final pipelineSlug = config.pipelineSlug;
    final pipelineInteraction =
        await validationDelegate.validateSourceProjectId(pipelineSlug);

    _processInteraction(
      interaction: pipelineInteraction,
      field: BuildkiteSourceConfigField.pipelineSlug,
    );

    return validationResultBuilder.build();
  }

  /// Processes the given [interaction].
  ///
  /// Maps the given [interaction] to a [FieldValidationResult] and
  /// sets the [field] validation result in [validationResultBuilder].
  void _processInteraction({
    @required InteractionResult interaction,
    @required BuildkiteSourceConfigField field,
  }) {
    final fieldValidationResult = _mapInteractionToFieldValidationResult(
      interaction,
    );

    validationResultBuilder.setResult(field, fieldValidationResult);
  }

  /// Sets empty fields of the [validationResultBuilder] with the
  /// [FieldValidationResult.unknown] with the given [interruptReason] as
  /// a [FieldValidationResult.additionalContext].
  void _setEmptyFields(String interruptReason) {
    final emptyFieldResult = FieldValidationResult.unknown(interruptReason);

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }

  /// Checks that the given [token] has enough scopes for organization slug
  /// validation.
  ///
  /// Returns `true` if the given [token] has the
  /// [BuildkiteTokenScope.readOrganizations] scope.
  ///
  /// Otherwise, returns `false`.
  bool _canValidateOrganization(BuildkiteToken token) {
    return token.scopes.contains(BuildkiteTokenScope.readOrganizations);
  }

  /// Checks that the given [token] has enough scopes for pipeline slug
  /// validation.
  ///
  /// Returns `true` if the given [token] has the
  /// [BuildkiteTokenScope.readPipelines] scope.
  ///
  /// Otherwise, returns `false`.
  bool _canValidatePipeline(BuildkiteToken token) {
    return token.scopes.contains(BuildkiteTokenScope.readPipelines);
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
}
