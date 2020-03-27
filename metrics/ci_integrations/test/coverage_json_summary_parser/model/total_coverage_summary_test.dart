import 'package:ci_integration/coverage_json_summary/model/coverage.dart';
import 'package:ci_integration/coverage_json_summary/model/total_covarage_summary.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("TotalCoverageSummary", () {
    test('.fromJson() returns null if json is null', () {
      final totalSummary = TotalCoverageSummary.fromJson(null);

      expect(totalSummary, null);
    });

    test('.fromJson() creates a new instance from decoded JSON object', () {
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

      expect(totalSummary, expectedTotalSummary);
    });

    test('.fromJson() creates an empty instance from the empty JSON', () {
      const expectedTotalSummary = TotalCoverageSummary();
      final totalSummary = TotalCoverageSummary.fromJson(const {});

      expect(totalSummary, expectedTotalSummary);
    });
  });
}
