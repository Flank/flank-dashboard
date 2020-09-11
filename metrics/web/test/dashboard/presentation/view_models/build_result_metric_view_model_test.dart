import 'package:collection/collection.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metrics_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultMetricsViewModel", () {
    test("throws an AssertionError if the given buildResults is null", () {
      expect(
        () => BuildResultMetricsViewModel(
          buildResults: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "throws an AssertionError if the given numberOfBuildsToDisplay is null",
      () {
        expect(
          () => BuildResultMetricsViewModel(
            buildResults: UnmodifiableListView([]),
            numberOfBuildsToDisplay: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(".buildResults is an UnmodifiableListView", () {
      final buildResultMetrics = BuildResultMetricsViewModel(
        buildResults: UnmodifiableListView([]),
      );

      expect(buildResultMetrics.buildResults, isA<UnmodifiableListView>());
    });

    test(
      "equals to another BuildResultMetricsViewModel with the same parameters",
      () {
        const buildResults = <BuildResultViewModel>[];
        const numberOfBuildsToDisplay = 10;
        final expected = BuildResultMetricsViewModel(
          buildResults: UnmodifiableListView(buildResults),
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
        );

        final buildResultMetrics = BuildResultMetricsViewModel(
          buildResults: UnmodifiableListView(buildResults),
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
        );

        expect(buildResultMetrics, equals(expected));
      },
    );
  });
}
