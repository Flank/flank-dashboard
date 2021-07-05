// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_conclusion.dart';
import 'package:metrics_core/src/util/validation/validation_result_builder.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';
import 'package:test/test.dart';

void main() {
  group("ValidationResultBuilder", () {
    const firstTarget = ValidationTarget(name: 'name');
    const secondTarget = ValidationTarget(name: 'another name');
    const targets = [firstTarget, secondTarget];
    const conclusion = ValidationConclusion(name: 'conclusion');
    const targetValidationResult = TargetValidationResult(
      target: firstTarget,
      conclusion: conclusion,
      description: 'description',
    );
    const anotherTargetValidationResult = TargetValidationResult(
      target: firstTarget,
      conclusion: conclusion,
      description: 'another description',
    );

    ValidationResultBuilder builder;

    setUp(() {
      builder = ValidationResultBuilder.forTargets(targets);
    });

    test(
      ".forTargets() throws an ArgumentError if the given targets is null",
      () {
        expect(
          () => ValidationResultBuilder.forTargets(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".forTargets() successfully creates an instance with the given targets",
      () {
        expect(
          () => ValidationResultBuilder.forTargets(targets),
          returnsNormally,
        );
      },
    );

    test(
      ".setResult() throws an ArgumentError if the target is not available",
      () {
        const nonAvailableTarget = ValidationTarget(name: 'not available');

        expect(
          () => builder.setResult(nonAvailableTarget, targetValidationResult),
          throwsArgumentError,
        );
      },
    );

    test(
      ".setResult() throws a StateError if the given target already has a target validation result",
      () {
        builder.setResult(firstTarget, targetValidationResult);

        expect(
          () => builder.setResult(firstTarget, targetValidationResult),
          throwsStateError,
        );
      },
    );

    test(
      ".setResult() sets the given target validation result to the given target",
      () {
        const target = ValidationTarget(name: 'name');
        final builder = ValidationResultBuilder.forTargets([target]);

        builder.setResult(target, targetValidationResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(validationResults, containsPair(target, targetValidationResult));
      },
    );

    test(
      ".setEmptyResults() sets the empty target validation results to the given result",
      () {
        builder.setEmptyResults(targetValidationResult);

        final result = builder.build();
        final fieldValidationResults = result.results.values;

        expect(
          fieldValidationResults,
          everyElement(equals(targetValidationResult)),
        );
      },
    );

    test(
      ".setEmptyResults() does not override the non-empty target validation results",
      () {
        builder.setResult(firstTarget, targetValidationResult);

        builder.setEmptyResults(anotherTargetValidationResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(
          validationResults,
          containsPair(firstTarget, targetValidationResult),
        );
      },
    );

    test(
      ".build() throws a StateError if there are targets with not specified target validation result",
      () {
        expect(
          () => builder.build(),
          throwsStateError,
        );
      },
    );

    test(
      ".build() returns a validation result containing target validation results that were set",
      () {
        builder.setResult(firstTarget, targetValidationResult);
        builder.setResult(secondTarget, anotherTargetValidationResult);

        final result = builder.build();
        final validationResults = result.results;

        expect(validationResults[firstTarget], equals(targetValidationResult));
        expect(
          validationResults[secondTarget],
          equals(anotherTargetValidationResult),
        );
      },
    );
  });
}
