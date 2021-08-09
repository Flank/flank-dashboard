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
    const validResult = ConfigFieldTargetValidationResult.valid(
      target: target,
    );
    const invalidResult = ConfigFieldTargetValidationResult.invalid(
      target: target,
    );
    const unknownResult = ConfigFieldTargetValidationResult.unknown(
      target: target,
    );

    test(
      ".valid() throws an AssertionError if the given target is null",
      () {
        expect(
          () => ConfigFieldTargetValidationResult.valid(target: null),
          throwsAssertionError,
        );
      },
    );

    test(
      ".valid() creates an instance with the valid field validation conclusion",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.conclusion, ConfigFieldValidationConclusion.valid);
      },
    );

    test(
      ".valid() creates an instance with an empty description if the description is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.description, isEmpty);
      },
    );

    test(
      ".valid() creates an instance with empty details if the details parameter is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.details, isEmpty);
      },
    );

    test(
      ".valid() creates an instance with an empty context if the context is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.valid(
          target: target,
        );

        expect(result.context, isEmpty);
      },
    );

    test(
      ".valid() creates an instance with the given parameters",
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
      ".isValid returns true if the result is valid",
      () {
        expect(validResult.isValid, isTrue);
      },
    );

    test(
      ".isInvalid returns false if the result is valid",
      () {
        expect(validResult.isInvalid, isFalse);
      },
    );

    test(
      ".isUnknown returns false if the result is valid",
      () {
        expect(validResult.isUnknown, isFalse);
      },
    );

    test(
      ".invalid() throws an AssertionError if the given target is null",
      () {
        expect(
          () => ConfigFieldTargetValidationResult.invalid(target: null),
          throwsAssertionError,
        );
      },
    );

    test(
      ".invalid() creates an instance with the invalid field validation conclusion",
      () {
        const result = ConfigFieldTargetValidationResult.invalid(
          target: target,
        );

        expect(result.conclusion, ConfigFieldValidationConclusion.invalid);
      },
    );

    test(
      ".invalid() creates an instance with an empty description if the given description is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.invalid(
          target: target,
        );

        expect(result.description, isEmpty);
      },
    );

    test(
      ".invalid() creates an instance with an empty details if the given details parameter is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.invalid(
          target: target,
        );

        expect(result.details, isEmpty);
      },
    );

    test(
      ".invalid() creates an instance with an empty context if the given context is not specified",
      () {
        const result = ConfigFieldTargetValidationResult.invalid(
          target: target,
        );

        expect(result.context, isEmpty);
      },
    );

    test(
      ".invalid() creates an instance with the given parameters",
      () {
        const result = ConfigFieldTargetValidationResult.invalid(
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
      ".isValid returns false if the result is invalid",
      () {
        expect(invalidResult.isValid, isFalse);
      },
    );

    test(
      ".isInvalid returns true if the result is invalid",
      () {
        expect(invalidResult.isInvalid, isTrue);
      },
    );

    test(
      ".isUnknown returns false if the result is invalid",
      () {
        expect(invalidResult.isUnknown, isFalse);
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
      ".unknown() creates an instance with an empty details if the given details parameter is not specified",
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
      ".isValid returns false if the result is unknown",
      () {
        expect(unknownResult.isValid, isFalse);
      },
    );

    test(
      ".isInvalid returns false if the result is unknown",
      () {
        expect(unknownResult.isInvalid, isFalse);
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
