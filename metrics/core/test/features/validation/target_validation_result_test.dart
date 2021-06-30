// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/features/validation/target_validation_result.dart';
import 'package:metrics_core/src/features/validation/validation_conclusion.dart';
import 'package:metrics_core/src/features/validation/validation_target.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("TargetValidationResult", () {
    const name = 'name';
    const value = 'value';
    const description = 'description';
    const data = 'data';
    const details = {'test': 'details'};
    const context = {'test': 'context'};
    const target = ValidationTarget(name: name, value: value);
    const conclusion = ValidationConclusion(name: name, value: value);

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
  });
}
