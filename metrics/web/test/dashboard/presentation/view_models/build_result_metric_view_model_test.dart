// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("BuildResultMetricViewModel", () {
    const numberOfBuildsToDisplay = 10;
    const maxBuildDuration = Duration.zero;

    final buildResults = UnmodifiableListView<BuildResultViewModel>([]);
    final firstBuildDate = DateTime(2020);
    final lastBuildDate = DateTime(2022);

    test("throws an AssertionError if the given build results is null", () {
      expect(
        () => BuildResultMetricViewModel(
          buildResults: null,
        ),
        throwsAssertionError,
      );
    });

    test(
      "throws an AssertionError if the given number of builds to display is null",
      () {
        expect(
          () => BuildResultMetricViewModel(
            buildResults: UnmodifiableListView([]),
            numberOfBuildsToDisplay: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(".buildResults is an UnmodifiableListView", () {
      final buildResultMetric = BuildResultMetricViewModel(
        buildResults: UnmodifiableListView([]),
      );

      expect(buildResultMetric.buildResults, isA<UnmodifiableListView>());
    });

    test("creates an instance with the given parameters", () {
      final metric = BuildResultMetricViewModel(
        buildResults: buildResults,
        numberOfBuildsToDisplay: numberOfBuildsToDisplay,
        metricPeriodStart: firstBuildDate,
        metricPeriodEnd: lastBuildDate,
        maxBuildDuration: maxBuildDuration,
      );

      expect(metric.buildResults, equals(buildResults));
      expect(metric.numberOfBuildsToDisplay, equals(numberOfBuildsToDisplay));
      expect(metric.metricPeriodStart, equals(firstBuildDate));
      expect(metric.metricPeriodEnd, equals(lastBuildDate));
      expect(metric.maxBuildDuration, equals(maxBuildDuration));
    });

    test(
      "equals to another BuildResultMetricViewModel with the same parameters",
      () {
        final expected = BuildResultMetricViewModel(
          buildResults: buildResults,
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          metricPeriodStart: firstBuildDate,
          metricPeriodEnd: lastBuildDate,
          maxBuildDuration: maxBuildDuration,
        );

        final buildResultMetric = BuildResultMetricViewModel(
          buildResults: buildResults,
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          metricPeriodStart: firstBuildDate,
          metricPeriodEnd: lastBuildDate,
          maxBuildDuration: maxBuildDuration,
        );

        expect(buildResultMetric, equals(expected));
      },
    );
  });
}
