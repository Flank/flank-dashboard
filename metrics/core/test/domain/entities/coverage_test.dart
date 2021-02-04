// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:metrics_core/src/domain/entities/coverage.dart';
import 'package:test/test.dart';

void main() {
  group("Coverage", () {
    test("creates an instance with the given parameters", () {
      final percent = Percent(0.3);

      final coverage = Coverage(percent: percent);

      expect(coverage.percent, equals(percent));
    });

    test(
      "equals to another Coverage instance if their values are the same",
      () {
        const percent = 0.6;

        final firstCoverage = Coverage(percent: Percent(percent));

        final secondCoverage = Coverage(percent: Percent(percent));

        expect(firstCoverage, equals(secondCoverage));
      },
    );
  });
}
