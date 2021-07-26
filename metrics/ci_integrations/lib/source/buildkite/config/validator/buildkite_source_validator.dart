// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config_field.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A class responsible for validating the [BuildkiteSourceConfig].
class BuildkiteSourceValidator
    implements ConfigValidatorStub<BuildkiteSourceConfig> {
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

    final authValidationResult = await validationDelegate.validateAuth(auth);
    validationResultBuilder.setResult(
      BuildkiteSourceConfigField.accessToken,
      authValidationResult,
    );

    if (authValidationResult.isFailure) {
      return _finalizeValidationResult(
        BuildkiteStrings.tokenInvalidInterruptReason,
      );
    }

    final token = authValidationResult.data;
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

    final organizationSlugValidationResult =
        await validationDelegate.validateOrganizationSlug(organizationSlug);
    validationResultBuilder.setResult(
      BuildkiteSourceConfigField.organizationSlug,
      organizationSlugValidationResult,
    );

    if (organizationSlugValidationResult.isFailure) {
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

    final pipelineSlugValidationResult =
        await validationDelegate.validatePipelineSlug(
      pipelineSlug,
    );
    validationResultBuilder.setResult(
      BuildkiteSourceConfigField.pipelineSlug,
      pipelineSlugValidationResult,
    );

    return validationResultBuilder.build();
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

  /// Sets the [FieldValidationResult.unknown] with the given
  /// [additionalContext] to the given [field] using
  /// the [validationResultBuilder].
  void _setUnknownFieldValidationResult(
    BuildkiteSourceConfigField field,
    String additionalContext,
  ) {
    final validationResult = FieldValidationResult.unknown(
      additionalContext: additionalContext,
    );

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
}
