import 'package:ci_integration/coverage/coverage_json_summary/model/coverage.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/total_coverage_summary.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("TotalCoverageSummary", () {
    test('.fromJson() should return null if the given JSON is null', () {
      final totalSummary = TotalCoverageSummary.fromJson(null);

      expect(totalSummary, isNull);
    });

    test(
      '.fromJson() should create a new instance from the decoded JSON object',
      () {
        const percent = 40;
        const totalSummaryJson = {
          'branches': {
            'pct': percent,
          }
        };

        final expectedTotalSummary = TotalCoverageSummary(
          branches: Coverage(percent: const Percent(percent / 100)),
        );

        final totalSummary = TotalCoverageSummary.fromJson(totalSummaryJson);

        expect(totalSummary, equals(expectedTotalSummary));
      },
    );

    test('.fromJson() should create an empty instance from the empty JSON', () {
      const expectedTotalSummary = TotalCoverageSummary();
      final totalSummary = TotalCoverageSummary.fromJson(const {});

      expect(totalSummary, equals(expectedTotalSummary));
    });
  });
}
