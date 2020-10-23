import 'package:metrics/dashboard/presentation/view_models/build_result_bar_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultBarViewModel", () {
    test("throws an AssertionError if the given duration is null", () {
      expect(
        () => BuildResultBarViewModel(
          duration: null,
          date: DateTime.now(),
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given date is null", () {
      expect(
        () => BuildResultBarViewModel(
          date: null,
          duration: Duration.zero,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "equals to another BuildResultBarViewModel with the same parameters",
      () {
        const duration = Duration.zero;
        const buildStatus = BuildStatus.unknown;
        const url = 'url';
        final date = DateTime.now();

        final expected = BuildResultBarViewModel(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        final buildResult = BuildResultBarViewModel(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}
