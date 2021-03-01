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
  /// A [BuildkiteSourceValidationDelegate] this validator uses
  /// for [BuildkiteSourceConfig]'s fields validation.
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
    ArgumentError.checkNotNull(validationDelegate, 'validationDelegate');
    ArgumentError.checkNotNull(
      validationResultBuilder,
      'validationResultBuilder',
    );
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
      return _finalizeValidationResult(
        BuildkiteStrings.tokenInvalidInterruptReason,
      );
    }

    final token = tokenInteraction.result;

    if (!_canValidateOrganization(token)) {
      _setUnknownFieldValidationResult(
        BuildkiteSourceConfigField.organizationSlug,
        BuildkiteStrings.noScopesToValidateOrganization,
      );

      return _finalizeValidationResult(
        BuildkiteStrings.organizationCantBeValidatedInterruptReason,
      );
    }

    final organizationSlug = config.organizationSlug;
    final organizationInteraction =
        await validationDelegate.validateOrganizationSlug(organizationSlug);

    _processInteraction(
      interaction: organizationInteraction,
      field: BuildkiteSourceConfigField.organizationSlug,
    );

    if (organizationInteraction.isError) {
      return _finalizeValidationResult(
        BuildkiteStrings.organizationInvalidInterruptReason,
      );
    }

    if (!_canValidatePipeline(token)) {
      _setUnknownFieldValidationResult(
        BuildkiteSourceConfigField.pipelineSlug,
        BuildkiteStrings.noScopesToValidatePipeline,
      );

      return validationResultBuilder.build();
    }

    final pipelineSlug = config.pipelineSlug;
    final pipelineInteraction = await validationDelegate.validatePipelineSlug(
      pipelineSlug,
    );

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
    final emptyFieldResult = FieldValidationResult.unknown(interruptReason);

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }

  /// Sets the [FieldValidationResult.unknown] with the given
  /// [additionalContext] to the given [field] using
  /// the [validationResultBuilder].
  void _setUnknownFieldValidationResult(
    BuildkiteSourceConfigField field,
    String additionalContext,
  ) {
    final validationResult = FieldValidationResult.unknown(additionalContext);

    validationResultBuilder.setResult(field, validationResult);
  }

  /// Checks that the given [token] has enough scopes for
  /// [BuildkiteSourceConfigField.organizationSlug] validation.
  bool _canValidateOrganization(BuildkiteToken token) {
    return _hasScope(token, BuildkiteTokenScope.readOrganizations);
  }

  /// Checks that the given [token] has enough scopes for
  /// [BuildkiteSourceConfigField.pipelineSlug] validation.
  bool _canValidatePipeline(BuildkiteToken token) {
    return _hasScope(token, BuildkiteTokenScope.readPipelines);
  }

  /// Checks that the given [token] has the given [scope].
  ///
  /// Returns `false` if the given [token] or its
  /// [BuildkiteToken.scopes] is `null`.
  ///
  /// Returns `true` if the given [token] contains the given [scope].
  ///
  /// Otherwise, returns `false`.
  bool _hasScope(BuildkiteToken token, BuildkiteTokenScope scope) {
    if (token == null || token.scopes == null) return false;

    return token.scopes.contains(scope);
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
