// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config_field.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/config/validator/buildkite_source_validator.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/extensions/interaction_result_answer.dart';
import '../../../../test_utils/matcher_util.dart';

void main() {
  group("BuildkiteSourceValidator", () {
    const accessToken = 'token';
    const organizationSlug = 'organization';
    const pipelineSlug = 'pipeline';
    const message = 'message';

    final config = BuildkiteSourceConfig(
      accessToken: accessToken,
      organizationSlug: organizationSlug,
      pipelineSlug: pipelineSlug,
    );

    final auth = BearerAuthorization(accessToken);

    const allRequiredScopesToken = BuildkiteToken(
      scopes: [
        BuildkiteTokenScope.readOrganizations,
        BuildkiteTokenScope.readPipelines,
      ],
    );
    const noOrganizationScopeToken = BuildkiteToken(
      scopes: [BuildkiteTokenScope.readPipelines],
    );
    const noPipelineScopeToken = BuildkiteToken(
      scopes: [BuildkiteTokenScope.readOrganizations],
    );

    final validationDelegate = _BuildkiteSourceValidationDelegateMock();

    ValidationResultBuilder validationResultBuilder;

    BuildkiteSourceValidator validator;

    setUp(() {
      validationResultBuilder = ValidationResultBuilder.forFields(
        BuildkiteSourceConfigField.values,
      );

      validator = BuildkiteSourceValidator(
        validationDelegate,
        validationResultBuilder,
      );
    });

    tearDown(() {
      reset(validationDelegate);
    });

    PostExpectation<Future<InteractionResult<BuildkiteToken>>>
        whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<InteractionResult>> whenValidateOrganizationSlug({
      BuildkiteToken withAccessToken,
    }) {
      whenValidateAuth().thenSuccessWith(withAccessToken);

      return when(
        validationDelegate.validateOrganizationSlug(organizationSlug),
      );
    }

    PostExpectation<Future<InteractionResult>> whenValidatePipelineSlug() {
      whenValidateOrganizationSlug(
        withAccessToken: allRequiredScopesToken,
      ).thenSuccessWith(null);

      return when(
        validationDelegate.validateSourceProjectId(pipelineSlug),
      );
    }

    /// Returns a [FieldValidationResult] for the
    /// [BuildkiteSourceConfigField.accessToken] from the given [result].
    FieldValidationResult _getAuthValidationResult(ValidationResult result) {
      return result.results[BuildkiteSourceConfigField.accessToken];
    }

    /// Returns a [FieldValidationResult] for the
    /// [BuildkiteSourceConfigField.pipelineSlug] from the given [result].
    FieldValidationResult _getPipelineSlugValidationResult(
      ValidationResult result,
    ) {
      return result.results[BuildkiteSourceConfigField.pipelineSlug];
    }

    /// Returns a [FieldValidationResult] for the
    /// [BuildkiteSourceConfigField.organizationSlug] from the given [result].
    FieldValidationResult _getOrganizationSlugValidationResult(
      ValidationResult result,
    ) {
      return result.results[BuildkiteSourceConfigField.organizationSlug];
    }

    test(
      "throws an ArgumentError if the given validation delegate is null",
      () {
        expect(
          () => BuildkiteSourceValidator(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => BuildkiteSourceValidator(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates a new instance with the given parameters",
      () {
        final validator = BuildkiteSourceValidator(
          validationDelegate,
          validationResultBuilder,
        );

        expect(validator.validationDelegate, equals(validationDelegate));
        expect(
          validator.validationResultBuilder,
          equals(validationResultBuilder),
        );
      },
    );

    test(
      ".validate() delegates the access token validation to the validation delegate",
      () {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken);

        final expectedAuth = BearerAuthorization(accessToken);

        validator.validate(config);

        verify(validationDelegate.validateAuth(expectedAuth)).called(1);
      },
    );

    test(
      ".validate() returns a validation result with the successful access token field validation result if the access token is valid",
      () async {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken);

        final result = await validator.validate(config);

        final validationResult = _getAuthValidationResult(result);

        expect(validationResult, MatcherUtil.isSuccessfulValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the access token field validation result, having the additional context equal to the message returned by the validation delegate if the access token is valid",
      () async {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken, message);

        final result = await validator.validate(config);

        final validationResult = _getAuthValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(additionalContext, equals(message));
      },
    );

    test(
      ".validate() returns a validation result with the failure access token field validation result if the access token is invalid",
      () async {
        whenValidateAuth().thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getAuthValidationResult(result);

        expect(validationResult, MatcherUtil.isFailureValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the access token field validation result, having the additional context equal to the message returned by the validation delegate if the access token is invalid",
      () async {
        whenValidateAuth().thenErrorWith(null, message);

        final result = await validator.validate(config);

        final validationResult = _getAuthValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(additionalContext, equals(message));
      },
    );

    test(
      ".validate() returns a validation result with the unknown organization slug field validation result if the access token is invalid",
      () async {
        whenValidateAuth().thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isUnknownValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the organization slug field validation result, having the additional context containing the token invalid interrupt reason if the access token is invalid",
      () async {
        whenValidateAuth().thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(
          additionalContext,
          equals(BuildkiteStrings.tokenInvalidInterruptReason),
        );
      },
    );

    test(
      ".validate() returns a validation result with the unknown pipeline slug field validation result if the access token is invalid",
      () async {
        whenValidateAuth().thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isUnknownValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the pipeline slug field validation result, having the additional context containing the token invalid interrupt reason if the access token is invalid",
      () async {
        whenValidateAuth().thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(
          additionalContext,
          equals(BuildkiteStrings.tokenInvalidInterruptReason),
        );
      },
    );

    test(
      ".validate() returns a validation result with the unknown organization slug field validation result if the access token has no scope to validate the organization",
      () async {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken);

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isUnknownValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the organization slug field validation result, having the additional context containing the no scopes to validate organization interrupt reason if the access token has no scope to validate the organization",
      () async {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken);

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(
          additionalContext,
          equals(BuildkiteStrings.noScopesToValidateOrganization),
        );
      },
    );

    test(
      ".validate() returns a validation result with the unknown pipeline slug field validation result if the access token has no scope to validate the organization",
      () async {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isUnknownValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the pipeline slug field validation result, having the additional context containing the organization can't be validated interrupt reason if the access token has no scope to validate the organization",
      () async {
        whenValidateAuth().thenSuccessWith(noOrganizationScopeToken);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(
          additionalContext,
          equals(BuildkiteStrings.organizationCantBeValidatedInterruptReason),
        );
      },
    );

    test(
      ".validate() delegates organization slug validation to the validation delegate",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: noPipelineScopeToken,
        ).thenSuccessWith(null);

        await validator.validate(config);

        verify(
          validationDelegate.validateOrganizationSlug(organizationSlug),
        ).called(1);
      },
    );

    test(
      ".validate() returns a validation result with the successful organization slug field validation result if the organization slug is valid",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: noPipelineScopeToken,
        ).thenSuccessWith(null);

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isSuccessfulValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the organization slug field validation result, having the additional context equal to the message returned the ion delegate if the organization slug is valid",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: noPipelineScopeToken,
        ).thenSuccessWith(null, message);

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(additionalContext, equals(message));
      },
    );

    test(
      ".validate() returns a validation result with the failure organization slug field validation result if the organization slug is invalid",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: allRequiredScopesToken,
        ).thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isFailureValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the organization slug field validation result, having the additional context equal to the message returned by the validation delegate if the organization slug is invalid",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: allRequiredScopesToken,
        ).thenErrorWith(null, message);

        final result = await validator.validate(config);

        final validationResult = _getOrganizationSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(additionalContext, equals(message));
      },
    );

    test(
      ".validate() returns a validation result with the unknown pipeline slug field validation result if the organization slug is invalid",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: allRequiredScopesToken,
        ).thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isUnknownValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the pipeline slug field validation result, having the additional context containing the organization invalid interrupt reason if the organization slug is invalid",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: allRequiredScopesToken,
        ).thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(
          additionalContext,
          equals(BuildkiteStrings.organizationInvalidInterruptReason),
        );
      },
    );

    test(
      ".validate() returns a validation result with the unknown pipeline slug field validation result if the access token hasn't scope to validate the pipeline slug",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: noPipelineScopeToken,
        ).thenSuccessWith(null);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isUnknownValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the pipeline slug field validation result, having the additional context containing the no scopes to validate pipeline interrupt reason if the access token hasn't scope to validate the pipeline slug",
      () async {
        whenValidateOrganizationSlug(
          withAccessToken: noPipelineScopeToken,
        ).thenSuccessWith(null);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(
          additionalContext,
          equals(BuildkiteStrings.noScopesToValidatePipeline),
        );
      },
    );

    test(
      ".validate() delegates the pipeline slug validation to the validation delegate",
      () async {
        whenValidatePipelineSlug().thenSuccessWith(null);

        await validator.validate(config);

        verify(
          validationDelegate.validateSourceProjectId(pipelineSlug),
        ).called(1);
      },
    );

    test(
      ".validate() returns a validation result with the successful pipeline slug field validation result if the pipeline slug is valid",
      () async {
        whenValidatePipelineSlug().thenSuccessWith(null);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isSuccessfulValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the pipeline slug field validation result, having the additional context equal to the message returned by the validation delegate if the pipeline slug is valid",
      () async {
        whenValidatePipelineSlug().thenSuccessWith(null, message);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(additionalContext, equals(message));
      },
    );

    test(
      ".validate() returns a validation result with the failure pipeline slug field validation result if the pipeline slug is invalid",
      () async {
        whenValidatePipelineSlug().thenErrorWith();

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);

        expect(validationResult, MatcherUtil.isFailureValidationResult);
      },
    );

    test(
      ".validate() returns a validation result with the pipeline slug field validation result, having the additional context equal to the message returned by the validation delegate if the pipeline slug is invalid",
      () async {
        whenValidatePipelineSlug().thenErrorWith(null, message);

        final result = await validator.validate(config);

        final validationResult = _getPipelineSlugValidationResult(result);
        final additionalContext = validationResult.additionalContext;

        expect(additionalContext, equals(message));
      },
    );
  });
}

class _BuildkiteSourceValidationDelegateMock extends Mock
    implements BuildkiteSourceValidationDelegate {}
