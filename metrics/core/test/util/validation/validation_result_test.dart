// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_conclusion.dart';
import 'package:metrics_core/src/util/validation/validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("ValidationResult", () {
    const name = 'name';
    const description = 'description';
    const target = ValidationTarget(name: name);
    const conclusion = ValidationConclusion(name: name);
    const targetValidationResult = TargetValidationResult(
      target: target,
      conclusion: conclusion,
      description: description,
    );

    final results = {
      target: targetValidationResult,
    };
    final result = ValidationResult(results);

    test(
      "throws an AssertionError if the given results is null",
      () {
        expect(() => ValidationResult(null), throwsAssertionError);
      },
    );

    test(
      "creates an instance with the given results",
      () {
        final validationResult = ValidationResult(results);

        expect(validationResult.results, equals(results));
      },
    );

    test(
      ".results is an unmodifiable map view",
      () {
        expect(result.results, isA<UnmodifiableMapView>());
      },
    );
  });
}
