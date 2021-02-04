// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/percent_view_model.dart';
import 'package:test/test.dart';

void main() {
  group("PercentViewModel", () {
    test("can be created with null value", () {
      expect(
        () => const PercentViewModel(null),
        returnsNormally,
      );
    });

    test("equals to another PercentViewModel instance with the same value", () {
      const value = 1.0;
      const expected = PercentViewModel(value);

      const percent = PercentViewModel(value);

      expect(percent, equals(expected));
    });
  });
}
