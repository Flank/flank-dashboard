import 'package:collection/collection.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultMetricViewModel", () {
    test("throws an AssertionError if the given buildResults is null", () {
      expect(
        () => BuildResultMetricViewModel(
          buildResults: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "throws an AssertionError if the given numberOfBuildsToDisplay is null",
      () {
        expect(
          () => BuildResultMetricViewModel(
            buildResults: UnmodifiableListView([]),
            numberOfBuildsToDisplay: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(".buildResults is an UnmodifiableListView", () {
      final buildResultMetric = BuildResultMetricViewModel(
        buildResults: UnmodifiableListView([]),
      );

      expect(buildResultMetric.buildResults, isA<UnmodifiableListView>());
    });

    test(
      "equals to another BuildResultMetricViewModel with the same parameters",
      () {
        const buildResults = <BuildResultViewModel>[];
        const numberOfBuildsToDisplay = 10;
        final expected = BuildResultMetricViewModel(
          buildResults: UnmodifiableListView(buildResults),
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
        );

        final buildResultMetric = BuildResultMetricViewModel(
          buildResults: UnmodifiableListView(buildResults),
          numberOfBuildsToDisplay: numberOfBuildsToDisplay,
        );

        expect(buildResultMetric, equals(expected));
      },
    );
  });
}
