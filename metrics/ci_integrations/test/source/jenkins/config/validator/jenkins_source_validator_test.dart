// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_validation_target.dart';
import 'package:ci_integration/source/jenkins/config/validation_delegate/jenkins_source_validation_delegate.dart';
import 'package:ci_integration/source/jenkins/config/validator/jenkins_source_validator.dart';
import 'package:ci_integration/source/jenkins/strings/jenkins_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/mock/validation_result_builder_mock.dart';

void main() {
  group("JenkinsSourceValidator", () {
    const url = 'url';
    const username = 'username';
    const jobName = 'job_name';
    const apiKey = 'api_key';
    const validConclusion = ConfigFieldValidationConclusion.valid;
    const invalidConclusion = ConfigFieldValidationConclusion.invalid;
    const unknownConclusion = ConfigFieldValidationConclusion.unknown;
    const urlTarget = JenkinsSourceValidationTarget.url;
    const apiTarget = JenkinsSourceValidationTarget.apiKey;
    const successResult = TargetValidationResult(
      target: urlTarget,
      conclusion: validConclusion,
    );
    const failureResult = TargetValidationResult(
      target: urlTarget,
      conclusion: invalidConclusion,
    );

    final config = JenkinsSourceConfig(
      url: url,
      username: username,
      apiKey: apiKey,
      jobName: jobName,
    );

    final auth = BasicAuthorization(username, apiKey);

    final validationDelegate = _JenkinsSourceValidationDelegateMock();
    final validationResultBuilder = ValidationResultBuilderMock();

    final validationResult = ValidationResult(const {});

    final validator = JenkinsSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );

    JenkinsSourceConfig createConfig({
      String username = username,
      String apiKey = apiKey,
    }) {
      return JenkinsSourceConfig(
        url: url,
        username: username,
        apiKey: apiKey,
        jobName: jobName,
      );
    }

    final noUsernameConfig = createConfig(username: null);
    final noApiKeyConfig = createConfig(apiKey: null);
    final noAuthConfig = createConfig(username: null, apiKey: null);

    PostExpectation<Future<TargetValidationResult<void>>> whenValidateUrl() {
      return when(validationDelegate.validateJenkinsUrl(url));
    }

    PostExpectation<Future<TargetValidationResult<void>>> whenValidateAuth() {
      whenValidateUrl().thenAnswer((_) => Future.value(successResult));

      return when(validationDelegate.validateAuth(auth));
    }

    PostExpectation<Future<TargetValidationResult<void>>>
        whenValidateJobName() {
      whenValidateAuth().thenAnswer((_) => Future.value(successResult));

      return when(validationDelegate.validateJobName(jobName));
    }

    tearDown(() {
      reset(validationDelegate);
      reset(validationResultBuilder);
    });

    test(
      "throws an ArgumentError if the given validation delegate is null",
      () {
        expect(
          () => JenkinsSourceValidator(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => JenkinsSourceValidator(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates a new instance with the given parameters",
      () {
        final validator = JenkinsSourceValidator(
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
      ".validate() delegates the url validation to the validation delegate",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(validationDelegate.validateJenkinsUrl(url)).called(once);
      },
    );

    test(
      ".validate() sets the url field validation result returned by validation delegate",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            JenkinsSourceValidationTarget.url,
            failureResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'jenkins url invalid' additional context if the url validation fails",
      () async {
        const expectedResult = TargetValidationResult(
          target: urlTarget,
          conclusion: unknownConclusion,
          description: JenkinsStrings.jenkinsUrlInvalidInterruptReason,
        );
        whenValidateUrl().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the auth if the url validation fails",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateAuth(any));
      },
    );

    test(
      ".validate() does not validate the job name if the url validation fails",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateJobName(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the url validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateUrl().thenAnswer((_) => Future.value(failureResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets empty results with the 'missing auth credentials' additional context if the username is missing in the config",
      () async {
        final missingCredentials = JenkinsSourceValidationTarget.username.name;
        final expectedInterruptReason =
            JenkinsStrings.missingAuthCredentialsInterruptReason(
          missingCredentials,
        );
        final expectedResult = TargetValidationResult(
          target: apiTarget,
          conclusion: unknownConclusion,
          description: expectedInterruptReason,
        );
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noUsernameConfig);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the auth if the username is missing in the config",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noUsernameConfig);

        verifyNever(validationDelegate.validateAuth(any));
      },
    );

    test(
      ".validate() does not validate the job name if the username is missing in the config",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noUsernameConfig);

        verifyNever(validationDelegate.validateJobName(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the username is missing in the config",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        final result = await validator.validate(noUsernameConfig);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets empty results with the 'missing auth credentials' additional context if the api key is missing in the config",
      () async {
        final missingCredentials = JenkinsSourceValidationTarget.apiKey.name;
        final expectedInterruptReason =
            JenkinsStrings.missingAuthCredentialsInterruptReason(
          missingCredentials,
        );
        final expectedResult = TargetValidationResult(
          target: apiTarget,
          conclusion: unknownConclusion,
          description: expectedInterruptReason,
        );
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noApiKeyConfig);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the auth if the api key is missing in the config",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noApiKeyConfig);

        verifyNever(validationDelegate.validateAuth(any));
      },
    );

    test(
      ".validate() does not validate the job name if the api key is missing in the config",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noApiKeyConfig);

        verifyNever(validationDelegate.validateJobName(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the api key is missing in the config",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        final result = await validator.validate(noApiKeyConfig);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() sets empty results with the 'missing auth credentials' additional context if the api key and username are missing in the config",
      () async {
        final missingCredentials = [
          JenkinsSourceValidationTarget.username,
          JenkinsSourceValidationTarget.apiKey
        ].map((field) => field.name).join(', ');
        final expectedInterruptReason =
            JenkinsStrings.missingAuthCredentialsInterruptReason(
          missingCredentials,
        );
        final expectedResult = TargetValidationResult(
          target: apiTarget,
          conclusion: unknownConclusion,
          description: expectedInterruptReason,
        );
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noAuthConfig);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the auth if the auth is missing in the config",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noAuthConfig);

        verifyNever(validationDelegate.validateAuth(any));
      },
    );

    test(
      ".validate() does not validate the job name if the auth is missing in the config",
      () async {
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        await validator.validate(noAuthConfig);

        verifyNever(validationDelegate.validateJobName(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the auth is missing in the config",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateUrl().thenAnswer((_) => Future.value(successResult));

        final result = await validator.validate(noAuthConfig);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the auth credentials validation to the validation delegate",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(validationDelegate.validateAuth(auth)).called(once);
      },
    );

    test(
      ".validate() sets the username field validation result returned by validation delegate",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            JenkinsSourceValidationTarget.username,
            failureResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets the api key field validation result returned by validation delegate",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            JenkinsSourceValidationTarget.apiKey,
            failureResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation results with the 'auth invalid' additional context if the auth credentials validation fails",
      () async {
        const expectedResult = TargetValidationResult(
          target: apiTarget,
          conclusion: unknownConclusion,
          description: JenkinsStrings.authInvalidInterruptReason,
        );
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the job name if the auth credentials validation fails",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateJobName(any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the auth credentials validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the job name validation to the validation delegate",
      () async {
        whenValidateJobName().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(validationDelegate.validateJobName(jobName)).called(once);
      },
    );

    test(
      ".validate() sets the job name field validation result returned by the validation delegate",
      () async {
        whenValidateJobName().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            JenkinsSourceValidationTarget.jobName,
            failureResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the job name validation fails",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateJobName().thenAnswer((_) => Future.value(failureResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns a validation result build by the validation result builder if the config is valid",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateJobName().thenAnswer((_) => Future.value(successResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _JenkinsSourceValidationDelegateMock extends Mock
    implements JenkinsSourceValidationDelegate {}
