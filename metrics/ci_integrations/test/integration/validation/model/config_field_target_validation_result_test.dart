// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/validation/model/config_field_target_validation_result.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("ConfigFieldTargetValidationResult", () {
    const description = 'description';
    const details = {'details': 'test'};
    const context = {'context': 'test'};
    const data = 'data';
    const target = ValidationTarget(name: 'target');
    const successResult = ConfigFieldTargetValidationResult.valid(
      target: target,
    );
    const failureResult = ConfigFieldTargetValidationResult.failure(
      target: target,
    );
    const unknownResult = ConfigFieldTargetValidationResult.unknown(
      target: target,
    );

    test(
      ".success() throws an AssertionError if the given target is null",
      () {
        expect(
          () => ConfigFieldTargetValidationResult.valid(target: null),
          throwsAssertionError,
        );
      },
    );

    test(
      ".success() creates an instance with the valid field validation conclusion",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.conclusion, ConfigFieldValidationConclusion.valid);
      },
    );

    test(
      ".success() creates an instance with an empty description if the description is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.description, isEmpty);
      },
    );

    test(
      ".success() creates an instance with empty details if the details are not specified",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.details, isEmpty);
      },
    );

    test(
      ".success() creates an instance with an empty context if the context is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.context, isEmpty);
      },
    );

    test(
      ".success() creates an instance with the given parameters",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
          description: description,
          details: details,
          context: context,
          data: data,
        );

        expect(result.target, equals(target));
        expect(result.description, equals(description));
        expect(result.details, equals(details));
        expect(result.context, equals(context));
        expect(result.data, equals(data));
      },
    );

    test(
      ".isSuccess returns true if the result is successful",
      () {
        expect(successResult.isSuccess, isTrue);
      },
    );

    test(
      ".isFailure returns false if the result is successful",
      () {
        expect(successResult.isFailure, isFalse);
      },
    );

    test(
      ".isUnknown returns false if the result is successful",
      () {
        expect(successResult.isUnknown, isFalse);
      },
    );

    test(
      ".failure() throws an AssertionError if the given target is null",
      () {
        expect(
          () => ConfigFieldTargetValidationResult.failure(target: null),
          throwsAssertionError,
        );
      },
    );

    test(
      ".failure() creates an instance with the invalid field validation conclusion",
      () {
        const result = ConfigFieldTargetValidationResult.failure(
          target: target,
        );

        expect(result.conclusion, ConfigFieldValidationConclusion.invalid);
      },
    );

    test(
      ".failure() creates an instance with an empty description if the given description is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.failure(
          target: target,
        );

        expect(result.description, isEmpty);
      },
    );

    test(
      ".failure() creates an instance with an empty details if the given details is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.failure(
          target: target,
        );

        expect(result.details, isEmpty);
      },
    );

    test(
      ".failure() creates an instance with an empty context if the given context is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.failure(
          target: target,
        );

        expect(result.context, isEmpty);
      },
    );

    test(
      ".failure() creates an instance with the given parameters",
      () {
        const result = ConfigFieldTargetValidationResult.failure(
          target: target,
          description: description,
          details: details,
          context: context,
          data: data,
        );

        expect(result.target, equals(target));
        expect(result.description, equals(description));
        expect(result.details, equals(details));
        expect(result.context, equals(context));
        expect(result.data, equals(data));
      },
    );

    test(
      ".isSuccess returns false if the result is failure",
      () {
        expect(failureResult.isSuccess, isFalse);
      },
    );

    test(
      ".isFailure returns true if the result is failure",
      () {
        expect(failureResult.isFailure, isTrue);
      },
    );

    test(
      ".isUnknown returns false if the result is failure",
      () {
        expect(failureResult.isUnknown, isFalse);
      },
    );

    test(
      ".unknown() throws an AssertionError if the given target is null",
      () {
        expect(
          () => ConfigFieldTargetValidationResult.unknown(target: null),
          throwsAssertionError,
        );
      },
    );

    test(
      ".unknown() creates an instance with the unknown field validation conclusion",
      () {
        const result = ConfigFieldTargetValidationResult.unknown(
          target: target,
        );

        expect(result.conclusion, ConfigFieldValidationConclusion.unknown);
      },
    );

    test(
      ".unknown() creates an instance with an empty description if the given description is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.unknown(
          target: target,
        );

        expect(result.description, isEmpty);
      },
    );

    test(
      ".unknown() creates an instance with an empty details if the given details is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.unknown(
          target: target,
        );

        expect(result.details, isEmpty);
      },
    );

    test(
      ".unknown() creates an instance with an empty context if the given context is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.unknown(
          target: target,
        );

        expect(result.context, isEmpty);
      },
    );

    test(
      ".unknown() creates an instance with the given parameters",
      () {
        const result = ConfigFieldTargetValidationResult.unknown(
          target: target,
          description: description,
          details: details,
          context: context,
          data: data,
        );

        expect(result.target, equals(target));
        expect(result.description, equals(description));
        expect(result.details, equals(details));
        expect(result.context, equals(context));
        expect(result.data, equals(data));
      },
    );

    test(
      ".isSuccess returns false if the result is unknown",
      () {
        expect(unknownResult.isSuccess, isFalse);
      },
    );

    test(
      ".isFailure returns false if the result is unknown",
      () {
        expect(unknownResult.isFailure, isFalse);
      },
    );

    test(
      ".isUnknown returns true if the result is unknown",
      () {
        expect(unknownResult.isUnknown, isTrue);
      },
    );
  });
}
