// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_auth_validation_result.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_validation_target.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("JenkinsSourceAuthValidationResult", () {
    const description = 'description';
    const validConclusion = ConfigFieldValidationConclusion.valid;
    const invalidConclusion = ConfigFieldValidationConclusion.invalid;
    const unknownConclusion = ConfigFieldValidationConclusion.unknown;
    const usernameValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.username,
      conclusion: validConclusion,
    );
    const apiKeyValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.apiKey,
      conclusion: validConclusion,
    );

    test(
      "throws an ArgumentError if the given username validation result is null",
      () {
        expect(
          () => JenkinsSourceAuthValidationResult(
            usernameValidationResult: null,
            apiKeyValidationResult: apiKeyValidationResult,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given api key validation result is null",
      () {
        expect(
          () => JenkinsSourceAuthValidationResult(
            usernameValidationResult: usernameValidationResult,
            apiKeyValidationResult: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".success() creates an instance with the correct validation targets for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.success();
        final usernameTarget = result.usernameValidationResult.target;
        final apiKeyTarget = result.apiKeyValidationResult.target;

        expect(usernameTarget, equals(JenkinsSourceValidationTarget.username));
        expect(apiKeyTarget, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".success() creates an instance with the valid config field validation conclusion for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.success();
        final usernameConclusion = result.usernameValidationResult.conclusion;
        final apiKeyConclusion = result.apiKeyValidationResult.conclusion;

        expect(usernameConclusion, equals(validConclusion));
        expect(apiKeyConclusion, equals(validConclusion));
      },
    );

    test(
      ".success() creates an instance with the given description for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.success(description);
        final usernameDescription = result.usernameValidationResult.description;
        final apiKeyDescription = result.apiKeyValidationResult.description;

        expect(usernameDescription, equals(description));
        expect(apiKeyDescription, equals(description));
      },
    );

    test(
      ".success() creates an instance with an empty description for both target validation results if the given description is null",
      () {
        final result = JenkinsSourceAuthValidationResult.success(null);
        final usernameDescription = result.usernameValidationResult.description;
        final apiKeyDescription = result.apiKeyValidationResult.description;

        expect(usernameDescription, isEmpty);
        expect(apiKeyDescription, isEmpty);
      },
    );

    test(
      ".failure() creates an instance with the correct validation targets for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.failure();
        final usernameTarget = result.usernameValidationResult.target;
        final apiKeyTarget = result.apiKeyValidationResult.target;

        expect(usernameTarget, equals(JenkinsSourceValidationTarget.username));
        expect(apiKeyTarget, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".failure() creates an instance with the invalid config field validation conclusion for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.failure();
        final usernameConclusion = result.usernameValidationResult.conclusion;
        final apiKeyConclusion = result.apiKeyValidationResult.conclusion;

        expect(usernameConclusion, equals(invalidConclusion));
        expect(apiKeyConclusion, equals(invalidConclusion));
      },
    );

    test(
      ".failure() creates an instance with the given description for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.failure(description);
        final usernameDescription = result.usernameValidationResult.description;
        final apiKeyDescription = result.apiKeyValidationResult.description;

        expect(usernameDescription, equals(description));
        expect(apiKeyDescription, equals(description));
      },
    );

    test(
      ".failure() creates an instance with an empty description for both target validation results if the given description is null",
      () {
        final result = JenkinsSourceAuthValidationResult.failure(null);
        final usernameDescription = result.usernameValidationResult.description;
        final apiKeyDescription = result.apiKeyValidationResult.description;

        expect(usernameDescription, isEmpty);
        expect(apiKeyDescription, isEmpty);
      },
    );

    test(
      ".unknown() creates an instance with the correct validation targets for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.unknown();
        final usernameTarget = result.usernameValidationResult.target;
        final apiKeyTarget = result.apiKeyValidationResult.target;

        expect(usernameTarget, equals(JenkinsSourceValidationTarget.username));
        expect(apiKeyTarget, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".unknown() creates an instance with the invalid config field validation conclusion for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.unknown();
        final usernameConclusion = result.usernameValidationResult.conclusion;
        final apiKeyConclusion = result.apiKeyValidationResult.conclusion;

        expect(usernameConclusion, equals(unknownConclusion));
        expect(apiKeyConclusion, equals(unknownConclusion));
      },
    );

    test(
      ".unknown() creates an instance with the given description for both target validation results",
      () {
        final result = JenkinsSourceAuthValidationResult.unknown(description);
        final usernameDescription = result.usernameValidationResult.description;
        final apiKeyDescription = result.apiKeyValidationResult.description;

        expect(usernameDescription, equals(description));
        expect(apiKeyDescription, equals(description));
      },
    );

    test(
      ".unknown() creates an instance with an empty description for both target validation results if the given description is null",
      () {
        final result = JenkinsSourceAuthValidationResult.unknown(null);
        final usernameDescription = result.usernameValidationResult.description;
        final apiKeyDescription = result.apiKeyValidationResult.description;

        expect(usernameDescription, isEmpty);
        expect(apiKeyDescription, isEmpty);
      },
    );

    test(
      "equals to another JenkinsSourceAuthValidationResult with the same parameters",
      () {
        final result = JenkinsSourceAuthValidationResult(
          usernameValidationResult: usernameValidationResult,
          apiKeyValidationResult: apiKeyValidationResult,
        );
        final anotherResult = JenkinsSourceAuthValidationResult(
          usernameValidationResult: usernameValidationResult,
          apiKeyValidationResult: apiKeyValidationResult,
        );

        expect(result, equals(anotherResult));
      },
    );
  });
}
