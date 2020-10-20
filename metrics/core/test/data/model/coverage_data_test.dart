import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageData", () {
    test(
      "throws an ArgumentError if the given percent is null",
      () {
        expect(() => CoverageData(percent: null), throwsArgumentError);
      },
    );

    test(".fromJson() returns null if the given JSON is null", () {
      final coverageModel = CoverageData.fromJson(null);

      expect(coverageModel, isNull);
    });

    test(
      ".fromJson() creates a new instance from the decoded JSON object",
      () {
        const percent = 0.6;
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
  });
}
