// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/integration/validation/model/config_field_target_validation_result.dart';
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
import '../../../../test_utils/mock/core_validation_result_builder_mock.dart';

void main() {
  group("BuildkiteSourceValidator", () {
    const accessToken = 'token';
    const organizationSlug = 'organization';
    const pipelineSlug = 'pipeline';
    const pipelineTarget = BuildkiteSourceValidationTarget.pipelineSlug;
    const accessTokenTarget = BuildkiteSourceValidationTarget.accessToken;
    const organizationTarget = BuildkiteSourceValidationTarget.organizationSlug;

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
    const invalidAccessTokenValidationResult =
        ConfigFieldTargetValidationResult.invalid(
      target: accessTokenTarget,
      data: null,
    );
    const pipelineScopeValidationResult =
        ConfigFieldTargetValidationResult.valid(
      target: pipelineTarget,
      data: pipelineScopeToken,
    );
    const invalidTargetValidationResult =
        ConfigFieldTargetValidationResult.invalid(target: pipelineTarget);
    const validTargetValidationResult =
        ConfigFieldTargetValidationResult.valid(target: pipelineTarget);

    final config = BuildkiteSourceConfig(
      accessToken: accessToken,
      organizationSlug: organizationSlug,
      pipelineSlug: pipelineSlug,
    );
    final auth = BearerAuthorization(accessToken);

    final validationDelegate = _BuildkiteSourceValidationDelegateMock();
    final validationResultBuilder = CoreValidationResultBuilderMock();
    final validator = BuildkiteSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );
    final results = {pipelineTarget: validTargetValidationResult};
    final validationResult = ValidationResult(results);

    PostExpectation<Future<ConfigFieldTargetValidationResult<BuildkiteToken>>>
        whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult>>
        whenValidateOrganizationSlug({
      BuildkiteToken accessToken,
    }) {
      whenValidateAuth().thenAnswer(
        (_) => Future.value(ConfigFieldTargetValidationResult.valid(
          target: accessTokenTarget,
          data: accessToken,
        )),
      );

      return when(
        validationDelegate.validateOrganizationSlug(organizationSlug),
      );
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult>>
        whenValidatePipelineSlug() {
      whenValidateOrganizationSlug(
        accessToken: allRequiredScopesToken,
      ).thenAnswer(
        (_) => Future.value(const ConfigFieldTargetValidationResult.valid(
          target: organizationTarget,
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
          (_) => Future.value(invalidAccessTokenValidationResult),
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
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(invalidAccessTokenValidationResult),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'token invalid' description if the access token validation fails",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: accessTokenTarget,
          description: BuildkiteStrings.tokenInvalidInterruptReason,
        );
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
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
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateOrganizationSlug(any));
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
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
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets the unknown organization slug target validation result with the 'no scopes to validate organization' description if the access token has no scope to validate the organization slug",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: organizationTarget,
          description: BuildkiteStrings.noScopesToValidateOrganization,
        );
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeValidationResult),
        );

        await validator.validate(config);

        verify(validationResultBuilder.setResult(expectedResult)).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'organization can't be validated' description if the access token has no scope to validate the organization slug",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: organizationTarget,
          description:
              BuildkiteStrings.organizationCantBeValidatedInterruptReason,
        );
        whenValidateAuth().thenAnswer(
          (_) => Future.value(pipelineScopeValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
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
        ).thenAnswer((_) => Future.value(invalidTargetValidationResult));

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
        ).thenAnswer((_) => Future.value(validTargetValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(validTargetValidationResult),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'organization slug is invalid' description after the organization slug validation fails",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: organizationTarget,
          description: BuildkiteStrings.organizationInvalidInterruptReason,
        );
        whenValidateOrganizationSlug(
          accessToken: allRequiredScopesToken,
        ).thenAnswer((_) => Future.value(invalidTargetValidationResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the organization slug validation fails",
      () async {
        whenValidateOrganizationSlug(
          accessToken: allRequiredScopesToken,
        ).thenAnswer((_) => Future.value(invalidTargetValidationResult));

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
        ).thenAnswer((_) => Future.value(invalidTargetValidationResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets the unknown pipeline slug target validation result with the 'no scopes to validate pipeline' description if the access token hasn't scope to validate the pipeline slug",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: pipelineTarget,
          description: BuildkiteStrings.noScopesToValidatePipeline,
        );
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(validTargetValidationResult));

        await validator.validate(config);

        verify(validationResultBuilder.setResult(expectedResult)).called(once);
      },
    );

    test(
      ".validate() does not validate the pipeline slug if the access token hasn't scope to validate the pipeline slug",
      () async {
        whenValidateOrganizationSlug(
          accessToken: organizationScopeToken,
        ).thenAnswer((_) => Future.value(validTargetValidationResult));

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
        ).thenAnswer((_) => Future.value(validTargetValidationResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the pipeline slug validation to the validation delegate",
      () async {
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(invalidTargetValidationResult),
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
          (_) => Future.value(pipelineScopeValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(pipelineScopeValidationResult),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the pipeline slug validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidatePipelineSlug().thenAnswer(
          (_) => Future.value(invalidTargetValidationResult),
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
          (_) => Future.value(validTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _BuildkiteSourceValidationDelegateMock extends Mock
    implements BuildkiteSourceValidationDelegate {}
