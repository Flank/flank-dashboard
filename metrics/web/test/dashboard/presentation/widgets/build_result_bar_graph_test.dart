import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metrics_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("BuildResultBarGraph", () {
    const buildResults = _BuildResultBarGraphTestbed.buildResultBarTestData;

    testWidgets(
      "throws an AssertionError if the given build result metrics is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
            const _BuildResultBarGraphTestbed(buildResultMetrics: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "creates the number of BuildResultBars equal to the number of builds to display",
      (WidgetTester tester) async {
        final buildResultMetrics = BuildResultMetricsViewModel(
          buildResults: UnmodifiableListView([]),
          numberOfBuildsToDisplay: 3,
        );

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetrics: buildResultMetrics,
        ));

        final barWidgets = tester.widgetList(find.byType(BuildResultBar));

        expect(barWidgets.length, buildResults.length);
      },
    );

    testWidgets(
      "creates an empty BuildResultBars to match the numberOfBuildsToDisplay",
      (WidgetTester tester) async {
        final numberOfBars = buildResults.length + 1;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetrics: BuildResultMetricsViewModel(
            buildResults: UnmodifiableListView(
              _BuildResultBarGraphTestbed.buildResultBarTestData,
            ),
            numberOfBuildsToDisplay: numberOfBars,
          ),
        ));

        final missingBuildResultsCount = numberOfBars - buildResults.length;

        final buildResultBars = tester.widgetList<BuildResultBar>(
          find.byType(BuildResultBar),
        );

        final emptyBuildResultBars = buildResultBars.where(
          (element) => element.buildResult == null,
        );

        expect(emptyBuildResultBars.length, missingBuildResultsCount);
      },
    );

    testWidgets(
      "trims the build results from the beginning to match the given number of bars",
      (WidgetTester tester) async {
        const numberOfBars = 2;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetrics: BuildResultMetricsViewModel(
            buildResults: UnmodifiableListView(
              _BuildResultBarGraphTestbed.buildResultBarTestData,
            ),
            numberOfBuildsToDisplay: numberOfBars,
          ),
        ));

        final trimmedData = buildResults
            .sublist(buildResults.length - numberOfBars)
            .map((barData) => barData.value);

        final barGraphWidget = tester.widget<BarGraph>(find.byWidgetPredicate(
          (widget) => widget is BarGraph,
        ));

        final barGraphData = barGraphWidget.data;

        expect(barGraphData.length, equals(numberOfBars));

        expect(barGraphData, equals(trimmedData));
      },
    );
  });
}

/// A testbed class required to test the [BuildResultBarGraph].
class _BuildResultBarGraphTestbed extends StatelessWidget {
  /// A list of [BuildResultViewModel] test data to test the [BuildResultBarGraph].
  static const buildResultBarTestData = [
    BuildResultViewModel(
      buildStatus: BuildStatus.successful,
      value: 5,
    ),
    BuildResultViewModel(
      buildStatus: BuildStatus.failed,
      value: 2,
    ),
    BuildResultViewModel(
      buildStatus: BuildStatus.cancelled,
      value: 8,
    ),
  ];

  /// A [BuildResultMetricsViewModel] to display.
  final BuildResultMetricsViewModel buildResultMetrics;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates the [_BuildResultBarGraphTestbed] with the given [buildResultMetrics].
  ///
  /// If the [buildResultMetrics] is not specified, the
  /// [buildResultMetricsTestData] used.
  /// If the [theme] is not specified, an empty [MetricsThemeData] used.
  const _BuildResultBarGraphTestbed({
    Key key,
    this.buildResultMetrics,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: BuildResultBarGraph(
        buildResultMetrics: buildResultMetrics,
      ),
    );
  }
}
