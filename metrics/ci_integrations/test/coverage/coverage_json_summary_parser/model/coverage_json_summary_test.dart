import 'package:ci_integration/coverage/coverage_json_summary/model/coverage.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/coverage_json_summary.dart';
import 'package:ci_integration/coverage/coverage_json_summary/model/total_coverage_summary.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageJsonSummary", () {
    test('.fromJson() should return null if the given JSON is null', () {
      final jsonSummary = CoverageJsonSummary.fromJson(null);

      expect(jsonSummary, isNull);
    });

    test(
      '.fromJson() should create a new instance from the decoded JSON object',
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
              percent: PercentValueObject(percent / 100),
            ),
          ),
        );

        final jsonSummary = CoverageJsonSummary.fromJson(coverageSummaryJson);

        expect(jsonSummary, equals(expectedJsonSummary));
      },
    );

    test('.fromJson() should create an empty instance from the empty JSON', () {
      const expectedJsonSummary = CoverageJsonSummary();

      final jsonSummary = CoverageJsonSummary.fromJson(const {});

      expect(jsonSummary, equals(expectedJsonSummary));
    });
  });
}
