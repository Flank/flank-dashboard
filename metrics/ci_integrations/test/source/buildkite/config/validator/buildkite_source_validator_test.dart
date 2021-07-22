// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config_field.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/config/validator/buildkite_source_validator.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/mock/validation_result_builder_stub_mock.dart';

void main() {
  group("BuildkiteSourceValidator", () {
    const accessToken = 'token';
    const organizationSlug = 'organization';
    const pipelineSlug = 'pipeline';

    const allRequiredScopesToken = BuildkiteToken(
      scopes: [
        BuildkiteTokenScope.readOrganizations,
        BuildkiteTokenScope.readPipelines,
      ],
    );
    const pipelineScopeToken = BuildkiteToken(
      scopes: [BuildkiteTokenScope.readPipelines],
    );
    const pipelineScopeTokenResult = FieldValidationResult.success(
      data: pipelineScopeToken,
    );
    const organizationScopeToken = BuildkiteToken(
      scopes: [BuildkiteTokenScope.readOrganizations],
    );
    const failureFieldValidationResult = FieldValidationResult.failure(
      data: null,
    );
    const successFieldValidationResult = FieldValidationResult.success(
      data: null,
    );

    final config = BuildkiteSourceConfig(
      accessToken: accessToken,
      organizationSlug: organizationSlug,
      pipelineSlug: pipelineSlug,
    );
    final auth = BearerAuthorization(accessToken);

    final validationDelegate = _BuildkiteSourceValidationDelegateMock();
    final validationResultBuilder = ValidationResultBuilderStubMock();
    final validator = BuildkiteSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );

    final field = BuildkiteSourceConfigField.pipelineSlug;
    const result = FieldValidationResult.success();
    final validationResult = ValidationResult({
      field: result,
    });

    PostExpectation<Future<FieldValidationResult<BuildkiteToken>>>
        whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<FieldValidationResult>>
        whenValidateOrganizationSlug({
      BuildkiteToken accessToken,
    }) {
      whenValidateAuth().thenAnswer(
        (_) => Future.value(FieldValidationResult.success(data: accessToken)),
      );

      return when(
        validationDelegate.validateOrganizationSlug(organizationSlug),
      );
    }

    PostExpectation<Future<FieldValidationResult>> whenValidatePipelineSlug() {
      whenValidateOrganizationSlug(
        accessToken: allRequiredScopesToken,
      ).thenAnswer((_) => Future.value(const FieldValidationResult.success()));

      return when(
        validationDelegate.validatePipelineSlug(pipelineSlug),
      );
    }

    tearDown(() {
      reset(validationDelegate);
      reset(validationResultBuilder);
    });

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
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        final expectedAuth = BearerAuthorization(accessToken);

        await validator.validate(config);

        verify(validationDelegate.validateAuth(expectedAuth)).called(once);
      },
    );

    test(
      ".validate() sets the access token field validation result returned by the validation delegate",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeTokenResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceConfigField.accessToken,
            pipelineScopeTokenResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'token invalid' additional context if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const FieldValidationResult.unknown(
              additionalContext: BuildkiteStrings.tokenInvalidInterruptReason,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the organization slug if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateOrganizationSlug(any));
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validatePipelineSlug(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the access token validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets the unknown organization slug field validation result with the 'no scopes to validate organization' additional context if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeTokenResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceConfigField.organizationSlug,
            const FieldValidationResult.unknown(
              additionalContext:
                  BuildkiteStrings.noScopesToValidateOrganization,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'organization can't be validated' additional context if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeTokenResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const FieldValidationResult.unknown(
              additionalContext:
                  BuildkiteStrings.organizationCantBeValidatedInterruptReason,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the organization slug if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeTokenResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateOrganizationSlug(any));
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeTokenResult),
        );
        await validator.validate(config);

        verifyNever(validationDelegate.validatePipelineSlug(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the access token has no scope to validate the organization slug",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeTokenResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates organization slug validation to the validation delegate",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(failureFieldValidationResult));

        await validator.validate(config);

        verify(
          validationDelegate.validateOrganizationSlug(organizationSlug),
        ).called(once);
      },
    );

    test(
      ".validate() sets the organization slug field validation result returned by the validation delegate",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(successFieldValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceConfigField.organizationSlug,
            successFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'organization slug is invalid' additional context after the organization slug validation fails",
      () async {
        whenValidateOrganizationSlug(
          accessToken: allRequiredScopesToken,
        ).thenAnswer((_) => Future.value(failureFieldValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const FieldValidationResult.unknown(
              additionalContext:
                  BuildkiteStrings.organizationInvalidInterruptReason,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the organization slug validation fails",
      () async {
        whenValidateOrganizationSlug(
          accessToken: allRequiredScopesToken,
        ).thenAnswer((_) => Future.value(failureFieldValidationResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validatePipelineSlug(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the organization slug validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateOrganizationSlug(
          accessToken: allRequiredScopesToken,
        ).thenAnswer((_) => Future.value(failureFieldValidationResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets the unknown pipeline slug field validation result with the 'no scopes to validate pipeline' if the access token hasn't scope to validate the pipeline slug",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(successFieldValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceConfigField.pipelineSlug,
            const FieldValidationResult.unknown(
              additionalContext: BuildkiteStrings.noScopesToValidatePipeline,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token hasn't scope to validate the pipeline slug",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(successFieldValidationResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validatePipelineSlug(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the access token hasn't scope to validate the pipeline slug",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(successFieldValidationResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the pipeline slug validation to the validation delegate",
      () async {
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validatePipelineSlug(pipelineSlug),
        ).called(once);
      },
    );

    test(
      ".validate() sets the pipeline slug field validation result returned by the validation delegate",
      () async {
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(successFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceConfigField.pipelineSlug,
            successFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the pipeline slug validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the config is valid",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(successFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _BuildkiteSourceValidationDelegateMock extends Mock
    implements BuildkiteSourceValidationDelegate {}
