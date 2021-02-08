// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("StabilityViewModel", () {
    test("can be created with null value", () {
      expect(
        () => const StabilityViewModel(value: null),
        returnsNormally,
      );
    });

    test(
      "equals to another StabilityViewModel instance with the same value",
      () {
        const value = 1.0;
        const expected = StabilityViewModel(value: value);

        const stability = StabilityViewModel(value: value);

        expect(stability, equals(expected));
      },
    );
  });
}
