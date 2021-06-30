// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/features/validation/validation_conclusion.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ValidationConclusion", () {
    const name = 'name';
    const indicator = '[+]';

    test(
      "throws an AssertionError if the given name is null",
      () {
        expect(
          () => ValidationConclusion(name: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const conclusion = ValidationConclusion(
          name: name,
          indicator: indicator,
        );

        expect(conclusion.name, equals(name));
        expect(conclusion.indicator, equals(indicator));
      },
    );
  });
}
