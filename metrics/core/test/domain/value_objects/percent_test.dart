// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("Percent", () {
    test("throws an ArgumentError if the given percent is null", () {
      expect(
        () => Percent(null),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given percent is less than 0.0", () {
      expect(
        () => Percent(-1.0),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given percent is more than 1.0", () {
      expect(
        () => Percent(1.1),
        throwsArgumentError,
      );
    });

    test("two instances with the equal value are equal", () {
      const percentValue = 0.1;
      final firstPercent = Percent(percentValue);
      final secondPercent = Percent(percentValue);

      expect(firstPercent, equals(secondPercent));
    });
  });
}
