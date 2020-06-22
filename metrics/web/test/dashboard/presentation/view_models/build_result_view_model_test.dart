import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultViewModel", () {
    test("throws an AssertionError if the given value is null", () {
      expect(
        () => BuildResultViewModel(
          value: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "equals to another BuildResultViewModel with the same parameters",
      () {
        const value = 10;
        const buildStatus = BuildStatus.cancelled;
        const url = 'url';
        const expected = BuildResultViewModel(
          value: value,
          buildStatus: buildStatus,
          url: url,
        );

        const buildResult = BuildResultViewModel(
          value: value,
          buildStatus: buildStatus,
          url: url,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}
