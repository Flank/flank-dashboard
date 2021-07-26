// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/config/validator/buildkite_source_validator.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/mock/validation_result_builder_mock.dart';

void main() {
  group("BuildkiteSourceValidator", () {
    const accessToken = 'token';
    const organizationSlug = 'organization';
    const pipelineSlug = 'pipeline';
    const pipelineTarget = BuildkiteSourceValidationTarget.pipelineSlug;
    const accessTokenTarget = BuildkiteSourceValidationTarget.accessToken;
    const organizationTarget = BuildkiteSourceValidationTarget.organizationSlug;
    const validConclusion = ConfigFieldValidationConclusion.valid;
    const invalidConclusion = ConfigFieldValidationConclusion.invalid;
    const unknownConclusion = ConfigFieldValidationConclusion.unknown;

    const allRequiredScopesToken = BuildkiteToken(
      scopes: [
        BuildkiteTokenScope.readOrganizations,
        BuildkiteTokenScope.readPipelines,
      ],
    );
    const pipelineScopeToken = BuildkiteToken(
      scopes: [BuildkiteTokenScope.readPipelines],
    );
    const organizationScopeToken = BuildkiteToken(
      scopes: [BuildkiteTokenScope.readOrganizations],
    );
    const accessTokenValidationResult = TargetValidationResult(
      target: accessTokenTarget,
      conclusion: invalidConclusion,
      data: null,
    );
    const pipelineScopeValidationResult = TargetValidationResult(
      target: pipelineTarget,
      conclusion: validConclusion,
      data: pipelineScopeToken,
    );
    const failureTargetValidationResult = TargetValidationResult(
      target: pipelineTarget,
      conclusion: invalidConclusion,
      data: null,
    );
    const successTargetValidationResult = TargetValidationResult(
      target: pipelineTarget,
      conclusion: validConclusion,
      data: null,
    );

    final config = BuildkiteSourceConfig(
      accessToken: accessToken,
      organizationSlug: organizationSlug,
      pipelineSlug: pipelineSlug,
    );
    final auth = BearerAuthorization(accessToken);

    final validationDelegate = _BuildkiteSourceValidationDelegateMock();
    final validationResultBuilder = ValidationResultBuilderMock();
    final validator = BuildkiteSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );
    final results = {pipelineTarget: successTargetValidationResult};
    final validationResult = ValidationResult(results);

    PostExpectation<Future<TargetValidationResult<BuildkiteToken>>>
        whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<TargetValidationResult>>
        whenValidateOrganizationSlug({
      BuildkiteToken accessToken,
    }) {
      whenValidateAuth().thenAnswer(
        (_) => Future.value(TargetValidationResult(
          target: pipelineTarget,
          conclusion: validConclusion,
          data: accessToken,
        )),
      );

      return when(
        validationDelegate.validateOrganizationSlug(organizationSlug),
      );
    }

    PostExpectation<Future<TargetValidationResult>> whenValidatePipelineSlug() {
      whenValidateOrganizationSlug(
        accessToken: allRequiredScopesToken,
      ).thenAnswer(
        (_) => Future.value(const TargetValidationResult(
          target: pipelineTarget,
          conclusion: validConclusion,
        )),
      );

      return when(
        validationDelegate.validatePipelineSlug(pipelineSlug),
      );
    }

    tearDown(() {
      reset(validationDelegate);
      reset(validationResultBuilder);
    });

    test(
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => BuildkiteSourceValidator(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation delegate is null",
      () {
        expect(
          () => BuildkiteSourceValidator(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
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
          (_) => Future.value(failureTargetValidationResult),
        );

        final expectedAuth = BearerAuthorization(accessToken);

        await validator.validate(config);

        verify(validationDelegate.validateAuth(expectedAuth)).called(once);
      },
    );

    test(
      ".validate() sets the access token target validation result returned by the validation delegate",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(accessTokenValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceValidationTarget.accessToken,
            accessTokenValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'token invalid' description if the access token validation fails",
      () async {
        const expectedResult = TargetValidationResult(
          target: accessTokenTarget,
          conclusion: unknownConclusion,
          description: BuildkiteStrings.tokenInvalidInterruptReason,
        );
        whenValidateAuth().thenAnswer(
          (_) => Future.value(accessTokenValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the organization slug if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateOrganizationSlug(any));
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets the unknown organization slug target validation result with the 'no scopes to validate organization' description if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            organizationTarget,
            const TargetValidationResult(
              target: organizationTarget,
              conclusion: unknownConclusion,
              description: BuildkiteStrings.noScopesToValidateOrganization,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'organization can't be validated' description if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const TargetValidationResult(
              target: organizationTarget,
              conclusion: unknownConclusion,
              description:
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
          (_) => Future.value(pipelineScopeValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateOrganizationSlug(any));
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token has no scope to validate the organization slug",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeValidationResult),
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
          (_) => Future.value(pipelineScopeValidationResult),
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
        ).thenAnswer((_) => Future.value(failureTargetValidationResult));

        await validator.validate(config);

        verify(
          validationDelegate.validateOrganizationSlug(organizationSlug),
        ).called(once);
      },
    );

    test(
      ".validate() sets the organization slug target validation result returned by the validation delegate",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(successTargetValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceValidationTarget.organizationSlug,
            successTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'organization slug is invalid' description after the organization slug validation fails",
      () async {
        whenValidateOrganizationSlug(
          accessToken: allRequiredScopesToken,
        ).thenAnswer((_) => Future.value(failureTargetValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const TargetValidationResult(
              target: organizationTarget,
              conclusion: unknownConclusion,
              description: BuildkiteStrings.organizationInvalidInterruptReason,
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
        ).thenAnswer((_) => Future.value(failureTargetValidationResult));

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
        ).thenAnswer((_) => Future.value(failureTargetValidationResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets the unknown pipeline slug target validation result with the 'no scopes to validate pipeline' description if the access token hasn't scope to validate the pipeline slug",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(successTargetValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceValidationTarget.pipelineSlug,
            const TargetValidationResult(
              target: pipelineTarget,
              conclusion: unknownConclusion,
              description: BuildkiteStrings.noScopesToValidatePipeline,
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
        ).thenAnswer((_) => Future.value(successTargetValidationResult));

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
        ).thenAnswer((_) => Future.value(successTargetValidationResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the pipeline slug validation to the validation delegate",
      () async {
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validatePipelineSlug(pipelineSlug),
        ).called(once);
      },
    );

    test(
      ".validate() sets the pipeline slug target validation result returned by the validation delegate",
      () async {
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(successTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            BuildkiteSourceValidationTarget.pipelineSlug,
            successTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the pipeline slug validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(successTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _BuildkiteSourceValidationDelegateMock extends Mock
    implements BuildkiteSourceValidationDelegate {}
