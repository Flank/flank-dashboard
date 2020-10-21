import 'package:metrics_core/metrics_core.dart';
import 'package:metrics_core/src/domain/entities/coverage.dart';
import 'package:test/test.dart';

void main() {
  group("Coverage", () {
    test(
      "throws an ArgumentError if the given percent is null",
      () {
        expect(() => Coverage(percent: null), throwsArgumentError);
      },
    );

    test(
      "two instances with the same percents are equal",
      () {
        const percent = 0.6;

        final firstCoverage = Coverage(percent: Percent(percent));

        final secondCoverage = Coverage(percent: Percent(percent));

        expect(firstCoverage, equals(secondCoverage));
      },
    );
  });
}
