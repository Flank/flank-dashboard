// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';

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
      BuildkiteSourceValidationTarget.accessToken,
      authValidationResult,
    );

    if (authValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        BuildkiteSourceValidationTarget.accessToken,
        BuildkiteStrings.tokenInvalidInterruptReason,
      );
    }

    final token = authValidationResult.data;
    if (!_canValidateOrganization(token)) {
      _setUnknownTargetValidationResult(
        BuildkiteSourceValidationTarget.organizationSlug,
        BuildkiteStrings.noScopesToValidateOrganization,
      );

      return _finalizeValidationResult(
        BuildkiteSourceValidationTarget.organizationSlug,
        BuildkiteStrings.organizationCantBeValidatedInterruptReason,
      );
    }

    final organizationSlug = config.organizationSlug;

    final organizationSlugValidationResult =
        await validationDelegate.validateOrganizationSlug(organizationSlug);
    validationResultBuilder.setResult(
      BuildkiteSourceValidationTarget.organizationSlug,
      organizationSlugValidationResult,
    );

    if (organizationSlugValidationResult.conclusion ==
        ConfigFieldValidationConclusion.invalid) {
      return _finalizeValidationResult(
        BuildkiteSourceValidationTarget.organizationSlug,
        BuildkiteStrings.organizationInvalidInterruptReason,
      );
    }

    if (!_canValidatePipeline(token)) {
      _setUnknownTargetValidationResult(
        BuildkiteSourceValidationTarget.pipelineSlug,
        BuildkiteStrings.noScopesToValidatePipeline,
      );

      return validationResultBuilder.build();
    }

    final pipelineSlug = config.pipelineSlug;

    final pipelineSlugValidationResult =
        await validationDelegate.validatePipelineSlug(pipelineSlug);
    validationResultBuilder.setResult(
      BuildkiteSourceValidationTarget.pipelineSlug,
      pipelineSlugValidationResult,
    );

    return validationResultBuilder.build();
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
  /// [TargetValidationResult] with the given [target] and [interruptReason],
  /// and [ConfigFieldValidationConclusion.unknown] as a
  /// [TargetValidationResult.conclusion].
  void _setEmptyTargets(ValidationTarget target, String interruptReason) {
    final emptyFieldResult = TargetValidationResult(
      target: target,
      conclusion: ConfigFieldValidationConclusion.unknown,
      description: interruptReason,
    );

    validationResultBuilder.setEmptyResults(emptyFieldResult);
  }

  /// Sets the [TargetValidationResult] with the
  /// [ConfigFieldValidationConclusion.unknown] conclusion and the given
  /// [description] to the given [target] using
  /// the [validationResultBuilder].
  void _setUnknownTargetValidationResult(
    ValidationTarget target,
    String description,
  ) {
    final validationResult = TargetValidationResult(
      target: target,
      conclusion: ConfigFieldValidationConclusion.unknown,
      description: description,
    );

    validationResultBuilder.setResult(target, validationResult);
  }

  /// Checks that the given [token] has enough scopes for
  /// [BuildkiteSourceValidationTarget.organizationSlug] validation.
  bool _canValidateOrganization(BuildkiteToken token) {
    return _hasScope(token, BuildkiteTokenScope.readOrganizations);
  }

  /// Checks that the given [token] has enough scopes for
  /// [BuildkiteSourceValidationTarget.pipelineSlug] validation.
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
