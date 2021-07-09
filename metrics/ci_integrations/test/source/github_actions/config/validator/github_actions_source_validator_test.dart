// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config.dart';
import 'package:ci_integration/source/github_actions/config/model/github_actions_source_config_field.dart';
import 'package:ci_integration/source/github_actions/config/validation_delegate/github_actions_source_validation_delegate.dart';
import 'package:ci_integration/source/github_actions/config/validator/github_actions_source_validator.dart';
import 'package:ci_integration/source/github_actions/strings/github_actions_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/mock/validation_result_builder_stub_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceValidator", () {
    const accessToken = 'accessToken';
    const repositoryOwner = 'repositoryOwner';
    const repositoryName = 'repositoryName';
    const workflowId = 'workflowId';
    const jobName = 'jobName';
    const coverageArtifactName = 'coverageArtifactName';
    const result = FieldValidationResult.success();

    const successFieldValidationResult = FieldValidationResult.success();
    const failureFieldValidationResult = FieldValidationResult.failure();
    const unknownFieldValidationResult = FieldValidationResult.unknown();

    final auth = BearerAuthorization(accessToken);
    final validationDelegate = _GithubActionsSourceValidationDelegateMock();
    final validationResultBuilder = ValidationResultBuilderStubMock();
    final validator = GithubActionsSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );
    final field = GithubActionsSourceConfigField.workflowIdentifier;
    final validationResult = ValidationResult({
      field: result,
    });

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

    PostExpectation<Future<FieldValidationResult<void>>> whenValidateAuth() {
      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<FieldValidationResult<void>>>
        whenValidateRepositoryOwner() {
      whenValidateAuth().thenAnswer(
        (_) => Future.value(successFieldValidationResult),
      );

      return when(
        validationDelegate.validateRepositoryOwner(repositoryOwner),
      );
    }

    PostExpectation<Future<FieldValidationResult<void>>>
        whenValidateRepositoryName() {
      whenValidateRepositoryOwner().thenAnswer(
        (_) => Future.value(successFieldValidationResult),
      );

      return when(
        validationDelegate.validateRepositoryName(
          repositoryName: repositoryName,
          repositoryOwner: repositoryOwner,
        ),
      );
    }

    PostExpectation<Future<FieldValidationResult<void>>>
        whenValidateWorkflowId() {
      whenValidateRepositoryName().thenAnswer(
        (_) => Future.value(successFieldValidationResult),
      );

      return when(
        validationDelegate.validateWorkflowId(workflowId),
      );
    }

    PostExpectation<Future<FieldValidationResult<void>>> whenValidateJobName() {
      whenValidateWorkflowId().thenAnswer(
        (_) => Future.value(successFieldValidationResult),
      );

      return when(
        validationDelegate.validateJobName(
          workflowId: workflowId,
          jobName: jobName,
        ),
      );
    }

    PostExpectation<Future<FieldValidationResult<void>>>
        whenValidateCoverageArtifactName() {
      whenValidateJobName().thenAnswer(
        (_) => Future.value(successFieldValidationResult),
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
      "creates a new instance with the given parameters",
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
      ".validate() sets the unknown access token field validation result with the 'token not specified' additional context if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.accessToken,
            const FieldValidationResult.unknown(
              additionalContext: GithubActionsStrings.tokenNotSpecified,
            ),
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'token not specified' additional context if the access token is null",
      () async {
        final config = createConfig(accessToken: null);

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(
            const FieldValidationResult.unknown(
              additionalContext:
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
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.accessToken,
            failureFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'token invalid' additional context if the access token validation fails",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext: GithubActionsStrings.tokenInvalidInterruptReason,
        );
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the access token validation fails",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the repository owner validation to the validation delegate",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.repositoryOwner,
            failureFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'repository owner invalid' additional context if the repository owner validation fails",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              GithubActionsStrings.repositoryOwnerInvalidInterruptReason,
        );
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the repository owner validation fails",
      () async {
        whenValidateRepositoryOwner().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates repository name validation to the validation delegate",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
      ".validate() sets the repository name field validation result returned by the validation delegate",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.repositoryName,
            failureFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'repository name invalid' additional context if the repository name validation fails",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              GithubActionsStrings.repositoryNameInvalidInterruptReason,
        );
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateWorkflowId(workflowId));
      },
    );

    test(
      ".validate() does not validate the job name if the repository name validation fails",
      () async {
        whenValidateRepositoryName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates workflow identifier validation to the validation delegate",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateWorkflowId(workflowId),
        ).called(once);
      },
    );

    test(
      ".validate() sets the workflow identifier field validation result returned by the validation delegate",
      () async {
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.workflowIdentifier,
            failureFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'workflow identifier invalid' additional context if the workflow identifier validation fails",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              GithubActionsStrings.workflowIdInvalidInterruptReason,
        );
        whenValidateWorkflowId().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(failureFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates job name validation to the validation delegate",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
      ".validate() sets the job name field validation result returned by the validation delegate",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.jobName,
            failureFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() validates the coverage artifact name if the job name validation fails",
      () async {
        whenValidateJobName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(unknownFieldValidationResult),
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
      ".validate() returns a field validation result built by the validation result builder if the job name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateJobName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(unknownFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates coverage artifact name validation to the validation delegate",
      () async {
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
      ".validate() sets the coverage artifact name field validation result returned by the validation delegate",
      () async {
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            GithubActionsSourceConfigField.coverageArtifactName,
            failureFieldValidationResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the coverage artifact name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateCoverageArtifactName().thenAnswer(
          (_) => Future.value(failureFieldValidationResult),
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
          (_) => Future.value(unknownFieldValidationResult),
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
          (_) => Future.value(successFieldValidationResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _GithubActionsSourceValidationDelegateMock extends Mock
    implements GithubActionsSourceValidationDelegate {}
