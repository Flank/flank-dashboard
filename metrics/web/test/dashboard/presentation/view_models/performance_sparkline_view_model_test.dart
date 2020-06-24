import 'dart:math';

import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("PerformanceSparklineViewModel", () {
    test("throws an AssertionError is the given performance is null", () {
      expect(
        () => PerformanceSparklineViewModel(
          performance: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError is the given value is null", () {
      expect(
        () => PerformanceSparklineViewModel(
          value: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "equals to another PerformanceSparklineViewModel with the same parameters",
      () {
        const performance = <Point<int>>[];
        const value = 10;
        const expected = PerformanceSparklineViewModel(
          performance: performance,
          value: value,
        );

        const performanceMetric = PerformanceSparklineViewModel(
          performance: performance,
          value: value,
        );

        expect(performanceMetric, equals(expected));
      },
    );
  });
}
