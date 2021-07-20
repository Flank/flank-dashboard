// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
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
import '../../../../test_utils/mock/validation_result_builder_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceValidator", () {
    const accessToken = 'accessToken';
    const repositoryOwner = 'repositoryOwner';
    const repositoryName = 'repositoryName';
    const workflowId = 'workflowId';
    const jobName = 'jobName';
    const coverageArtifactName = 'coverageArtifactName';
    const validConclusion = ConfigFieldValidationConclusion.valid;
    const invalidConclusion = ConfigFieldValidationConclusion.invalid;
    const unknownConclusion = ConfigFieldValidationConclusion.unknown;
    const tokenTarget = GithubActionsSourceValidationTarget.accessToken;
    const repositoryOwnerTarget =
        GithubActionsSourceValidationTarget.repositoryOwner;
    const repositoryNameTarget =
        GithubActionsSourceValidationTarget.repositoryName;
    const workflowTarget =
        GithubActionsSourceValidationTarget.workflowIdentifier;
    const successTargetValidationResult = TargetValidationResult(
      target: workflowTarget,
      conclusion: validConclusion,
    );
    const failureTargetValidationResult = TargetValidationResult(
      target: workflowTarget,
      conclusion: invalidConclusion,
    );
    const unknownTargetValidationResult = TargetValidationResult(
      target: workflowTarget,
      conclusion: unknownConclusion,
    );

    final auth = BearerAuthorization(accessToken);
    final validationDelegate = _GithubActionsSourceValidationDelegateMock();
    final validationResultBuilder = ValidationResultBuilderMock();
    final validator = GithubActionsSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );
    final result = {workflowTarget: successTargetValidationResult};
    final validationResult = ValidationResult(result);

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

    PostExpectation<Future<TargetValidationResult<void>>> whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<TargetValidationResult<void>>>
        whenValidateRepositoryOwner() {
      whenValidateAuth().thenAnswer(
        (_) => Future.value(successTargetValidationResult),
      );

      return when(
        validationDelegate.validateRepositoryOwner(repositoryOwner),
      );
    }

    PostExpectation<Future<TargetValidationResult<void>>>
        whenValidateRepositoryName() {
      whenValidateRepositoryOwner().thenAnswer(
        (_) => Future.value(successTargetValidationResult),
      );

      return when(
        validationDelegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        ),
      );
    }

    PostExpectation<Future<TargetValidationResult<void>>>
        whenValidateWorkflowId() {
      whenValidateRepositoryName().thenAnswer(
        (_) => Future.value(successTargetValidationResult),
      );

      return when(
        validationDelegate.validateWorkflowId(workflowId),
      );
    }

    PostExpectation<Future<TargetValidationResult<void>>>
        whenValidateJobName() {
      whenValidateWorkflowId().thenAnswer(
        (_) => Future.value(successTargetValidationResult),
      );

      return when(
        validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ),
      );
    }

    PostExpectation<Future<TargetValidationResult<void>>>
        whenValidateCoverageArtifactName() {
      whenValidateJobName().thenAnswer(
        (_) => Future.value(successTargetValidationResult),
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
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => GithubActionsSourceValidator(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation delegate is null",
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
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.accessToken,
            const TargetValidationResult(
              target: tokenTarget,
              conclusion: unknownConclusion,
              description: GithubActionsStrings.tokenNotSpecified,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'token not specified' description if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const TargetValidationResult(
              target: tokenTarget,
              conclusion: unknownConclusion,
              description:
                  GithubActionsStrings.tokenNotSpecifiedInterruptReason,
            ),
          ),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.accessToken,
            failureTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'token invalid' description if the access token validation fails",
      () async {
        const expectedResult = TargetValidationResult(
          target: tokenTarget,
          conclusion: unknownConclusion,
          description: GithubActionsStrings.tokenInvalidInterruptReason,
        );
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the repository owner validation to the validation delegate",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateRepositoryOwner(repositoryOwner),
        ).called(once);
      },
    );

    test(
      ".validate() sets the repository owner target validation result returned by the validation delegate",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.repositoryOwner,
            failureTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'repository owner invalid' description if the repository owner validation fails",
      () async {
        const expectedResult = TargetValidationResult(
            target: repositoryOwnerTarget,
            conclusion: unknownConclusion,
            description:
                GithubActionsStrings.repositoryOwnerInvalidInterruptReason);
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            expectedResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the repository name if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates repository name validation to the validation delegate",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.repositoryName,
            failureTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'repository name invalid' description if the repository name validation fails",
      () async {
        const expectedResult = TargetValidationResult(
          target: repositoryNameTarget,
          conclusion: unknownConclusion,
          description:
              GithubActionsStrings.repositoryNameInvalidInterruptReason,
        );
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the repository name validation fails",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates workflow identifier validation to the validation delegate",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.workflowIdentifier,
            failureTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown target validation result with the 'workflow identifier invalid' description if the workflow identifier validation fails",
      () async {
        const expectedResult = TargetValidationResult(
          target: workflowTarget,
          conclusion: unknownConclusion,
          description: GithubActionsStrings.workflowIdInvalidInterruptReason,
        );
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates job name validation to the validation delegate",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.jobName,
            failureTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() validates the coverage artifact name if the job name validation fails",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(unknownTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(unknownTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates coverage artifact name validation to the validation delegate",
      () async {
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(failureTargetValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceValidationTarget.coverageArtifactName,
            failureTargetValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the coverage artifact name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(failureTargetValidationResult),
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
          (_) => Future.value(unknownTargetValidationResult),
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
          (_) => Future.value(successTargetValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _GithubActionsSourceValidationDelegateMock extends Mock
    implements GithubActionsSourceValidationDelegate {}
