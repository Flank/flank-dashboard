import 'dart:math';

import 'package:metrics/dashboard/presentation/view_models/performance_metric_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("PerformanceMetricViewModel", () {
    test("can't be created with null performance", () {
      expect(
        () => PerformanceMetricViewModel(
          performance: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("can't be created with null value", () {
      expect(
        () => PerformanceMetricViewModel(
          value: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "equals to another PerformanceMetricViewModel with the same parameters",
      () {
        const performance = <Point<int>>[];
        const value = 10;
        const expected = PerformanceMetricViewModel(
          performance: performance,
          value: value,
        );

        const performanceMetric = PerformanceMetricViewModel(
          performance: performance,
          value: value,
        );

        expect(performanceMetric, equals(expected));
      },
    );
  });
}
