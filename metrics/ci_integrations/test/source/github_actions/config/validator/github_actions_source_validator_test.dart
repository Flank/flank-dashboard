// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_target_validation_result.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_validation_target.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/config/validator/github_actions_source_validator.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/mock/core_validation_result_builder_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceValidator", () {
    const accessToken = 'accessToken';
    const repositoryOwner = 'repositoryOwner';
    const repositoryName = 'repositoryName';
    const workflowId = 'workflowId';
    const jobName = 'jobName';
    const coverageArtifactName = 'coverageArtifactName';
    const accessTokenTarget = GithubActionsSourceValidationTarget.accessToken;
    const repositoryOwnerTarget =
        GithubActionsSourceValidationTarget.repositoryOwner;
    const repositoryNameTarget =
        GithubActionsSourceValidationTarget.repositoryName;
    const workflowIdTarget =
        GithubActionsSourceValidationTarget.workflowIdentifier;
    const jobNameTarget = GithubActionsSourceValidationTarget.jobName;
    const coverageArtifactNameTarget =
        GithubActionsSourceValidationTarget.coverageArtifactName;

    const unknownAccessTokenValidationResult =
        ConfigFieldTargetValidationResult.unknown(
      target: accessTokenTarget,
      description: GithubActionsStrings.tokenNotSpecified,
    );
    const invalidAccessTokenValidationResult =
        ConfigFieldTargetValidationResult.invalid(target: accessTokenTarget);
    const invalidRepositoryOwnerValidationResult =
        ConfigFieldTargetValidationResult.invalid(
      target: repositoryOwnerTarget,
    );
    const invalidRepositoryNameValidationResult =
        ConfigFieldTargetValidationResult.invalid(
      target: repositoryNameTarget,
    );
    const invalidWorkflowIdValidationResult =
        ConfigFieldTargetValidationResult.invalid(
      target: workflowIdTarget,
    );
    const invalidJobNameValidationResult =
        ConfigFieldTargetValidationResult.invalid(target: jobNameTarget);
    const unknownJobNameValidationResult =
        ConfigFieldTargetValidationResult.unknown(target: jobNameTarget);
    const invalidCoverageNameValidationResult =
        ConfigFieldTargetValidationResult.invalid(
      target: coverageArtifactNameTarget,
    );
    const unknownCoverageNameValidationResult =
        ConfigFieldTargetValidationResult.unknown(
      target: coverageArtifactNameTarget,
    );
    const validTargetValidationResult =
        ConfigFieldTargetValidationResult.valid(target: accessTokenTarget);
    final results = {accessTokenTarget: validTargetValidationResult};
    final validationResult = ValidationResult(results);
    // const result = FieldValidationResult.success();

    // const successFieldValidationResult = FieldValidationResult.success();
    // const failureFieldValidationResult = FieldValidationResult.failure();
    // const unknownFieldValidationResult = FieldValidationResult.unknown();

    final auth = BearerAuthorization(accessToken);
    final validationDelegate = _GithubActionsSourceValidationDelegateMock();
    final validationResultBuilder = CoreValidationResultBuilderMock();
    final validator = GithubActionsSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );
    // final field = GithubActionsSourceConfigField.workflowIdentifier;
    // final validationResult = ValidationResult({
    //   field: result,
    // });

    GithubActionsSourceConfig createConfig({
      String accessToken = accessToken,
      String repositoryOwner = repositoryOwner,
      String repositoryName = repositoryName,
      String workflowIdentifier = workflowId,
      String jobName = jobName,
      String coverageArtifactName = coverageArtifactName,
    }) {
      return GithubActionsSourceConfig(
        accessToken: accessToken,
        repositoryOwner: repositoryOwner,
        repositoryName: repositoryName,
        workflowIdentifier: workflowId,
        jobName: jobName,
        coverageArtifactName: coverageArtifactName,
      );
    }

    final config = createConfig();

    PostExpectation<Future<ConfigFieldTargetValidationResult<void>>>
        whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult<void>>>
        whenValidateRepositoryOwner() {
      whenValidateAuth().thenAnswer(
        (_) => Future.value(
          const ConfigFieldTargetValidationResult.valid(
            target: accessTokenTarget,
          ),
        ),
      );

      return when(
        validationDelegate.validateRepositoryOwner(repositoryOwner),
      );
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult<void>>>
        whenValidateRepositoryName() {
      whenValidateRepositoryOwner().thenAnswer(
        (_) => Future.value(
          const ConfigFieldTargetValidationResult.valid(
            target: repositoryOwnerTarget,
          ),
        ),
      );

      return when(
        validationDelegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        ),
      );
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult<void>>>
        whenValidateWorkflowId() {
      whenValidateRepositoryName().thenAnswer(
        (_) => Future.value(
          const ConfigFieldTargetValidationResult.valid(
            target: repositoryNameTarget,
          ),
        ),
      );

      return when(
        validationDelegate.validateWorkflowId(workflowId),
      );
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult<void>>>
        whenValidateJobName() {
      whenValidateWorkflowId().thenAnswer(
        (_) => Future.value(
          const ConfigFieldTargetValidationResult.valid(
            target: workflowIdTarget,
          ),
        ),
      );

      return when(
        validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ),
      );
    }

    PostExpectation<Future<ConfigFieldTargetValidationResult<void>>>
        whenValidateCoverageArtifactName() {
      whenValidateJobName().thenAnswer(
        (_) => Future.value(
          const ConfigFieldTargetValidationResult.valid(
            target: jobNameTarget,
          ),
        ),
      );

      return when(
        validationDelegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        ),
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
          () => GithubActionsSourceValidator(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => GithubActionsSourceValidator(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final validator = GithubActionsSourceValidator(
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
      ".validate() sets the unknown access token target validation result with the 'token not specified' description if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(unknownAccessTokenValidationResult),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'token not specified' description if the access token is null",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: accessTokenTarget,
          description: GithubActionsStrings.tokenNotSpecifiedInterruptReason,
        );
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the access token if the access token is null",
      () async {
        final config = createConfig(accessToken: null);
        final authorization = BearerAuthorization(config.accessToken);

        await validator.validate(config);

        verifyNever(
          validationDelegate.validateAuth(authorization),
        );
      },
    );

    test(
      ".validate() does not validate the repository owner if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verifyNever(
          validationDelegate.validateRepositoryOwner(repositoryOwner),
        );
      },
    );

    test(
      ".validate() does not validate the repository name if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verifyNever(validationDelegate.validateRepositoryName(
          repositoryOwner: repositoryOwner,
          repositoryName: repositoryName,
        ));
      },
    );

    test(
      ".validate() does not validate the workflow identifier if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verifyNever(
          validationDelegate.validateJobName(
            workflowId: workflowId,
            jobName: jobName,
          ),
        );
      },
    );

    test(
      ".validate() does not validate the coverage artifact name if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verifyNever(
          validationDelegate.validateCoverageArtifactName(
            workflowId: workflowId,
            coverageArtifactName: coverageArtifactName,
          ),
        );
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        when(validationResultBuilder.build()).thenReturn(validationResult);

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
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
          description: GithubActionsStrings.tokenInvalidInterruptReason,
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
      ".validate() does not validate the repository owner if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verifyNever(
          validationDelegate.validateRepositoryOwner(repositoryOwner),
        );
      },
    );

    test(
      ".validate() does not validate the repository name if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateRepositoryName(
          repositoryOwner: repositoryOwner,
          repositoryName: repositoryName,
        ));
      },
    );

    test(
      ".validate() does not validate the workflow identifier if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ));
      },
    );

    test(
      ".validate() does not validate the coverage artifact name if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(invalidAccessTokenValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        ));
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
      ".validate() delegates the repository owner validation to the validation delegate",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateRepositoryOwner(repositoryOwner),
        ).called(once);
      },
    );

    test(
      ".validate() sets the repository owner field validation result returned by the validation delegate",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            invalidRepositoryOwnerValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'repository owner invalid' description if the repository owner validation fails",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: repositoryOwnerTarget,
          description:
              GithubActionsStrings.repositoryOwnerInvalidInterruptReason,
        );
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the repository name if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateRepositoryName(
          repositoryOwner: repositoryOwner,
          repositoryName: repositoryName,
        ));
      },
    );

    test(
      ".validate() does not validate the workflow identifier if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ));
      },
    );

    test(
      ".validate() does not validate the coverage artifact name if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        ));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the repository owner validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(invalidRepositoryOwnerValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates repository name validation to the validation delegate",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateRepositoryName(
            repositoryName: repositoryName,
            repositoryOwner: repositoryOwner,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets the repository name target validation result returned by the validation delegate",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            invalidRepositoryNameValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'repository name invalid' description if the repository name validation fails",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: repositoryNameTarget,
          description:
              GithubActionsStrings.repositoryNameInvalidInterruptReason,
        );
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the workflow identifier if the repository name validation fails",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the repository name validation fails",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ));
      },
    );

    test(
      ".validate() does not validate the coverage artifact name if the repository name validation fails",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        ));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the repository name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(invalidRepositoryNameValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates workflow identifier validation to the validation delegate",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(invalidWorkflowIdValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateWorkflowId(workflowId),
        ).called(once);
      },
    );

    test(
      ".validate() sets the workflow identifier target validation result returned by the validation delegate",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(invalidWorkflowIdValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(invalidWorkflowIdValidationResult),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'workflow identifier invalid' description if the workflow identifier validation fails",
      () async {
        const expectedResult = ConfigFieldTargetValidationResult.unknown(
          target: workflowIdTarget,
          description: GithubActionsStrings.workflowIdInvalidInterruptReason,
        );
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(invalidWorkflowIdValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the job name if the workflow identifier validation fails",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(invalidWorkflowIdValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ));
      },
    );

    test(
      ".validate() does not validate the coverage artifact name if the workflow identifier validation fails",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(invalidWorkflowIdValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateCoverageArtifactName(
          workflowId: workflowId,
          coverageArtifactName: coverageArtifactName,
        ));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the workflow identifier validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(invalidWorkflowIdValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates job name validation to the validation delegate",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(invalidJobNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateJobName(
            workflowId: workflowId,
            jobName: jobName,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets the job name target validation result returned by the validation delegate",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(invalidJobNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(invalidJobNameValidationResult),
        ).called(once);
      },
    );

    test(
      ".validate() validates the coverage artifact name if the job name validation fails",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(invalidJobNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateCoverageArtifactName(
            workflowId: workflowId,
            coverageArtifactName: coverageArtifactName,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() validates the coverage artifact name if the job name validation result is unknown",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(unknownJobNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateCoverageArtifactName(
            workflowId: workflowId,
            coverageArtifactName: coverageArtifactName,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a target validation result built by the validation result builder if the job name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateJobName().thenAnswer(
          (_) => Future.value(invalidJobNameValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the job name validation result is unknown",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateJobName().thenAnswer(
          (_) => Future.value(unknownJobNameValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates coverage artifact name validation to the validation delegate",
      () async {
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(invalidCoverageNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateCoverageArtifactName(
            workflowId: workflowId,
            coverageArtifactName: coverageArtifactName,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets the coverage artifact name target validation result returned by the validation delegate",
      () async {
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(invalidCoverageNameValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            invalidCoverageNameValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the coverage artifact name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(invalidCoverageNameValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the coverage artifact name validation result is unknown",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(unknownCoverageNameValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the config is valid",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(validTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _GithubActionsSourceValidationDelegateMock extends Mock
    implements GithubActionsSourceValidationDelegate {}
