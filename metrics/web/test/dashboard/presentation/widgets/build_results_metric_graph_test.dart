// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar_graph/theme_data/build_result_bar_graph_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/build_results_metric_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultsMetricGraph", () {
    final metricPeriodStart = DateTime(2020);
    final metricPeriodEnd = DateTime(2021);

    final dateFormat = DateFormat('d MMM');

    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: Duration.zero,
      date: DateTime.now(),
    );

    List<BuildResultViewModel> createBuildResults(int count) {
      return List.generate(count, (_) {
        return FinishedBuildResultViewModel(
          duration: const Duration(seconds: 5),
          date: DateTime.now(),
          buildStatus: BuildStatus.successful,
          buildResultPopupViewModel: buildResultPopupViewModel,
        );
      });
    }

    BuildResultMetricViewModel createBuildResultMetric({
      List<BuildResultViewModel> buildResults,
      int numberOfBuildsToDisplay,
      DateTime metricPeriodStart,
      DateTime metricPeriodEnd,
    }) {
      return BuildResultMetricViewModel(
        buildResults: UnmodifiableListView(
          buildResults ?? createBuildResults(5),
        ),
        numberOfBuildsToDisplay: numberOfBuildsToDisplay ?? 5,
        metricPeriodStart: metricPeriodStart,
        metricPeriodEnd: metricPeriodEnd,
      );
    }

    final buildResultBarGraphFinder = find.byType(BuildResultBarGraph);
    final barGraphPaddingFinder = find.ancestor(
      of: buildResultBarGraphFinder,
      matching: find.byType(Padding),
    );

    testWidgets(
      "throws an AssertionError if the given build result metric view model is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildResultsMetricGraphTestbed(buildResultMetric: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies a text style from the build result bar graph theme data",
      (WidgetTester tester) async {
        const expectedTextStyle = TextStyle(color: Colors.red);
        const theme = MetricsThemeData(
          buildResultBarGraphTheme: BuildResultBarGraphThemeData(
            textStyle: expectedTextStyle,
          ),
        );

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            metricPeriodStart: metricPeriodStart,
            metricPeriodEnd: metricPeriodEnd,
          ),
          theme: theme,
        ));

        final textWidget = tester.widget<Text>(find.byType(Text));
        final actualTextStyle = textWidget.style;

        expect(actualTextStyle, equals(expectedTextStyle));
      },
    );

    testWidgets(
      "displays a date range from the view model",
      (WidgetTester tester) async {
        final firstDate = dateFormat.format(metricPeriodStart);
        final lastDate = dateFormat.format(metricPeriodEnd);
        final expectedText = '$firstDate - $lastDate';

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            metricPeriodStart: metricPeriodStart,
            metricPeriodEnd: metricPeriodEnd,
          ),
        ));

        expect(find.text(expectedText), findsOneWidget);
      },
    );

    testWidgets(
      "displays only one date in the date range if the start and end of the metric period are equal",
      (WidgetTester tester) async {
        final expectedText = dateFormat.format(metricPeriodStart);

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            metricPeriodStart: metricPeriodStart,
            metricPeriodEnd: metricPeriodStart,
          ),
        ));

        expect(find.text(expectedText), findsOneWidget);
      },
    );

    testWidgets(
      "does not display the date range if the metric period dates are null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            metricPeriodStart: null,
            metricPeriodEnd: null,
          ),
        ));

        expect(find.byType(Text), findsNothing);
      },
    );

    testWidgets(
      "creates empty build result bars to match the number of builds to display",
      (WidgetTester tester) async {
        const numberOfBuildsToDisplay = 30;
        const numberOfBuilds = 20;

        const expectedNumberOfEmptyBars =
            numberOfBuildsToDisplay - numberOfBuilds;

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            buildResults: createBuildResults(numberOfBuilds),
            numberOfBuildsToDisplay: numberOfBuildsToDisplay,
          ),
        ));

        final emptyBuildResultBarFinder = find.byWidgetPredicate((widget) {
          return widget is BuildResultBar && widget.buildResult == null;
        });

        expect(
          emptyBuildResultBarFinder,
          findsNWidgets(expectedNumberOfEmptyBars),
        );
      },
    );

    testWidgets(
      "displays a build result bar graph with the given build result metric view model",
      (WidgetTester tester) async {
        final expectedBuildResultMetric = createBuildResultMetric();

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: expectedBuildResultMetric,
        ));

        final buildResultBarGraph = tester.widget<BuildResultBarGraph>(
          buildResultBarGraphFinder,
        );

        expect(
          buildResultBarGraph.buildResultMetric,
          equals(expectedBuildResultMetric),
        );
      },
    );

    testWidgets(
      "applies the build result duration strategy to the build result bar graph",
      (WidgetTester tester) async {
        final expectedBuildResultMetric = createBuildResultMetric();

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: expectedBuildResultMetric,
        ));

        final buildResultBarGraph = tester.widget<BuildResultBarGraph>(
          buildResultBarGraphFinder,
        );

        expect(
          buildResultBarGraph.durationStrategy,
          isA<BuildResultDurationStrategy>(),
        );
      },
    );

    testWidgets(
      "applies a padding from the left to the build result bar graph if there are missing builds",
      (WidgetTester tester) async {
        const expectedPadding = EdgeInsets.only(left: 2.0);
        const numberOfBuilds = 20;

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            buildResults: createBuildResults(numberOfBuilds),
            numberOfBuildsToDisplay: numberOfBuilds + 1,
          ),
        ));

        final barGraphPadding = tester.widget<Padding>(barGraphPaddingFinder);

        expect(barGraphPadding.padding, equals(expectedPadding));
      },
    );

    testWidgets(
      "applies a zero padding to the build result bar graph if there are no missing builds",
      (WidgetTester tester) async {
        final expectedPadding = EdgeInsets.zero;

        await tester.pumpWidget(_BuildResultsMetricGraphTestbed(
          buildResultMetric: createBuildResultMetric(
            buildResults: createBuildResults(20),
            numberOfBuildsToDisplay: 20,
          ),
        ));

        final barGraphPadding = tester.widget<Padding>(barGraphPaddingFinder);

        expect(barGraphPadding.padding, equals(expectedPadding));
      },
    );
  });
}

/// A testbed class required to test the [BuildResultsMetricGraph].
class _BuildResultsMetricGraphTestbed extends StatelessWidget {
  /// A [BuildResultMetricViewModel] with the data to display.
  final BuildResultMetricViewModel buildResultMetric;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates the [_BuildResultBarGraphTestbed] with the given [buildResultMetric].
  ///
  /// If the [theme] is not specified, an empty [MetricsThemeData] used.
  const _BuildResultsMetricGraphTestbed({
    Key key,
    this.buildResultMetric,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: BuildResultsMetricGraph(
        buildResultMetric: buildResultMetric,
      ),
    );
  }
}
