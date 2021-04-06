// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/date_range_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("BuildResultMetricViewModel", () {
    const numberOfBuildsToDisplay = 10;
    const maxBuildDuration = Duration.zero;

    final buildResults = UnmodifiableListView<BuildResultViewModel>([]);
    final startDate = DateTime(2020);
    final endDate = DateTime(2021);
    final dateRange = DateRangeViewModel(start: startDate, end: endDate);

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
        dateRangeViewModel: dateRange,
        maxBuildDuration: maxBuildDuration,
      );

      expect(metric.buildResults, equals(buildResults));
      expect(metric.numberOfBuildsToDisplay, equals(numberOfBuildsToDisplay));
      expect(metric.dateRangeViewModel, equals(dateRange));
      expect(metric.maxBuildDuration, equals(maxBuildDuration));
    });

    test(
      "equals to another BuildResultMetricViewModel with the same parameters",
      () {
        final expected = BuildResultMetricViewModel(
          buildResults: buildResults,
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          dateRangeViewModel: dateRange,
          maxBuildDuration: maxBuildDuration,
        );

        final buildResultMetric = BuildResultMetricViewModel(
          buildResults: buildResults,
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          dateRangeViewModel: dateRange,
          maxBuildDuration: maxBuildDuration,
        );

        expect(buildResultMetric, equals(expected));
      },
    );
  });
}
