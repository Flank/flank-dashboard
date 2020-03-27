import 'package:ci_integration/coverage_json_summary/model/coverage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("Coverage", () {
    test(
      "can't be created with the null percent",
      () {
        expect(() => Coverage(percent: null), throwsArgumentError);
      },
    );

    test('.fromJson() returns null if the JSON is null', () {
      final coverage = Coverage.fromJson(null);

      expect(coverage, isNull);
    });

    test('.fromJson() creates a new instance from decoded JSON object', () {
      const percent = 30;
      const coverageJson = {'pct': percent};
      final expectedCoverage = Coverage(percent: const Percent(percent / 100));
      
      final coverage = Coverage.fromJson(coverageJson);

      expect(coverage, expectedCoverage);
    });
  });
}
