// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("CoverageViewModel", () {
    test("can be created with null value", () {
      expect(
        () => const CoverageViewModel(value: null),
        returnsNormally,
      );
    });

    test(
      "equals to another CoverageViewModel instance with the same value",
      () {
        const value = 1.0;
        const expected = CoverageViewModel(value: value);

        const coverage = CoverageViewModel(value: value);

        expect(coverage, equals(expected));
      },
    );
  });
}
