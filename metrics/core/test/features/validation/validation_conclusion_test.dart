// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/features/validation/validation_conclusion.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ValidationConclusion", () {
    const name = 'name';
    const value = 'value';
    const indicator = '[+]';

    test(
      "throws an AssertionError if the given name is null",
      () {
        expect(
          () => ValidationConclusion(name: null, value: value),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given value is null",
      () {
        expect(
          () => ValidationConclusion(name: name, value: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const conclusion = ValidationConclusion(
          name: name,
          value: value,
          indicator: indicator,
        );

        expect(conclusion.name, equals(name));
        expect(conclusion.value, equals(value));
        expect(conclusion.indicator, equals(indicator));
      },
    );
  });
}
