// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_conclusion.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("TargetValidationResult", () {
    const name = 'name';
    const description = 'description';
    const data = 'data';
    const details = {'test': 'details'};
    const context = {'test': 'context'};
    const target = ValidationTarget(name: name);
    const conclusion = ValidationConclusion(name: name);

    test(
      "throws an AssertionError if the given target is null",
      () {
        expect(
          () => TargetValidationResult(
            target: null,
            conclusion: conclusion,
            description: description,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given conclusion is null",
      () {
        expect(
          () => TargetValidationResult(
            target: target,
            conclusion: null,
            description: description,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given description is null",
      () {
        expect(
          () => TargetValidationResult(
            target: target,
            conclusion: conclusion,
            description: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          description: description,
          details: details,
          context: context,
          data: data,
        );

        expect(result.target, equals(target));
        expect(result.conclusion, equals(conclusion));
        expect(result.description, equals(description));
        expect(result.details, equals(details));
        expect(result.context, equals(context));
        expect(result.data, equals(data));
      },
    );

    test(
      "creates an instance with an empty details if the given details are not specified",
      () {
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          description: description,
        );

        expect(result.details, isEmpty);
      },
    );

    test(
      "creates an instance with an empty context if the given context is not specified",
      () {
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          description: description,
        );

        expect(result.context, isEmpty);
      },
    );

    test(
      ",copyWith() creates a new instance from the existing one",
      () {
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          description: description,
          details: details,
          context: context,
          data: data,
        );
        const anotherName = 'another name';
        const anotherDescription = 'another description';
        const anotherData = 'another data';
        const anotherDetails = {'test': 'another details'};
        const anotherContext = {'test': 'another context'};
        const anotherTarget = ValidationTarget(name: anotherName);
        const anotherConclusion = ValidationConclusion(name: anotherName);

        final copiedResult = result.copyWith(
          target: anotherTarget,
          conclusion: anotherConclusion,
          description: anotherDescription,
          details: anotherDetails,
          context: anotherContext,
          data: anotherData,
        );

        expect(copiedResult.target, equals(anotherTarget));
        expect(copiedResult.conclusion, equals(anotherConclusion));
        expect(copiedResult.description, equals(anotherDescription));
        expect(copiedResult.details, equals(anotherDetails));
        expect(copiedResult.context, equals(anotherContext));
        expect(copiedResult.data, equals(anotherData));
      },
    );

    test(
      ",copyWith() creates a new instance with the same fields if called without parameters",
      () {
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          description: description,
          details: details,
          context: context,
          data: data,
        );

        final copiedResult = result.copyWith();

        expect(copiedResult.target, equals(result.target));
        expect(copiedResult.conclusion, equals(result.conclusion));
        expect(copiedResult.description, equals(result.description));
        expect(copiedResult.details, equals(result.details));
        expect(copiedResult.context, equals(result.context));
        expect(copiedResult.data, equals(result.data));
      },
    );
  });
}
