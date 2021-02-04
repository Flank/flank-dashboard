// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageData", () {
    const percent = 0.6;
    final json = {
      'pct': percent,
    };

    test("creates an instance with the given parameters", () {
      final percent = Percent(0.3);

      final coverageData = CoverageData(percent: percent);

      expect(coverageData.percent, equals(percent));
    });

    test(".fromJson() returns null if the given JSON is null", () {
      final coverageModel = CoverageData.fromJson(null);

      expect(coverageModel, isNull);
    });

    test(
      ".fromJson() creates a new instance from the decoded JSON object",
      () {
        const coverageJson = {
          'pct': percent,
        };

        final expectedCoverageModel = CoverageData(
          percent: Percent(percent),
        );

        final coverageModel = CoverageData.fromJson(coverageJson);

        expect(coverageModel, equals(expectedCoverageModel));
      },
    );

    test(".toJson() converts an instance to the json encodable map", () {
      final coverageData = CoverageData(percent: Percent(percent));

      expect(coverageData.toJson(), equals(json));
    });
  });
}
