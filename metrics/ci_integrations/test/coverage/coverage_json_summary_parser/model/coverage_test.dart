import 'package:ci_integration/coverage/coverage_json_summary/model/coverage.dart';
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

    test('.fromJson() should return null if the given JSON is null', () {
      final coverage = Coverage.fromJson(null);

      expect(coverage, isNull);
    });

    test(
        '.fromJson() should create a new instance from the decoded JSON object',
        () {
      const percent = 30;
      const coverageJson = {'pct': percent};
      final expectedCoverage = Coverage(percent: const Percent(percent / 100));

      final coverage = Coverage.fromJson(coverageJson);

      expect(coverage, equals(expectedCoverage));
    });
  });
}
