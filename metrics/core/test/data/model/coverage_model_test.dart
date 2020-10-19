import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageModel", () {
    test(
      "can't be created with the null percent",
      () {
        expect(() => CoverageModel(percent: null), throwsArgumentError);
      },
    );

    test('.fromJson() returns null if the given JSON is null', () {
      final coverageModel = CoverageModel.fromJson(null);

      expect(coverageModel, isNull);
    });

    test(
      '.fromJson() creates a new instance from the decoded JSON object',
      () {
        const percent = 100;
        const coverageJson = {
          'pct': percent,
        };

        final expectedCoverageModel = CoverageModel(
          percent: Percent(percent / 100),
        );

        final coverageModel = CoverageModel.fromJson(coverageJson);

        expect(coverageModel, equals(expectedCoverageModel));
      },
    );
  });
}
