import 'package:ci_integration/coverage/coverage_json_summary/model/coverage.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/coverage_json_summary.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/total_covarage_summary.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageJsonSummary", () {
    test('.fromJson() returns null if the json is null', () {
      final jsonSummary = CoverageJsonSummary.fromJson(null);

      expect(jsonSummary, isNull);
    });

    test(
      '.fromJson() creates a new instance from the decoded JSON object',
      () {
        const percent = 100;
        const coverageSummaryJson = {
          'total': {
            'branches': {
              'pct': percent,
            }
          }
        };

        final expectedJsonSummary = CoverageJsonSummary(
          total: TotalCoverageSummary(
            branches: Coverage(
              percent: const Percent(percent / 100),
            ),
          ),
        );

        final jsonSummary = CoverageJsonSummary.fromJson(coverageSummaryJson);

        expect(jsonSummary, equals(expectedJsonSummary));
      },
    );

    test('.fromJson() creates an empty instance from the empty JSON', () {
      const expectedJsonSummary = CoverageJsonSummary();

      final jsonSummary = CoverageJsonSummary.fromJson(const {});

      expect(jsonSummary, equals(expectedJsonSummary));
    });
  });
}
