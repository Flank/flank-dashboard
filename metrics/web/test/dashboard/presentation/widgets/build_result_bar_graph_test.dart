// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar_graph/theme_data/build_result_bar_graph_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBarGraph", () {
    final buildResults = _BuildResultBarGraphTestbed.buildResultBarTestData;
    final barGraphFinder = find.byWidgetPredicate(
      (widget) => widget is BarGraph<int>,
    );

    testWidgets(
      "throws an AssertionError if the given build result metric is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildResultBarGraphTestbed(buildResultMetric: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies a text style from the metrics theme",
      (WidgetTester tester) async {
        const expectedTextStyle = TextStyle(color: Colors.red);
        const theme = MetricsThemeData(
          buildResultBarGraphTheme: BuildResultBarGraphThemeData(
            textStyle: expectedTextStyle,
          ),
        );

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: buildResults.length,
          ),
          theme: theme,
        ));

        final textWidget = tester.widget<Text>(find.byType(Text));
        final actualTextStyle = textWidget.style;

        expect(actualTextStyle, equals(expectedTextStyle));
      },
    );

    testWidgets(
      "displays a date range text",
      (WidgetTester tester) async {
        final dateFormat = DateFormat('d MMM');
        final firstDate = buildResults.first.date;
        final lastDate = buildResults.last.date;
        final firstDateFormatted = dateFormat.format(firstDate);
        final lastDateFormatted = dateFormat.format(lastDate);
        final expected = '$firstDateFormatted - $lastDateFormatted';

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        expect(find.text(expected), findsOneWidget);
      },
    );

    testWidgets(
      "displays a text with the single date if dates of build results are equal",
      (WidgetTester tester) async {
        final firstDate = buildResults.first.date;
        final expected = DateFormat('d MMM').format(firstDate);

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView([
              buildResults.first,
              buildResults.first,
            ]),
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        expect(find.text(expected), findsOneWidget);
      },
    );

    testWidgets(
      "does not display the date range text if the list of build results is empty",
      (WidgetTester tester) async {
        final emptyBuildResults = <BuildResultViewModel>[];

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(emptyBuildResults),
            numberOfBuildsToDisplay: emptyBuildResults.length,
          ),
        ));

        expect(find.byType(Text), findsNothing);
      },
    );

    testWidgets(
      "creates the number of BuildResultBars equal to the number of builds to display",
      (WidgetTester tester) async {
        final buildResultMetric = BuildResultMetricViewModel(
          buildResults: UnmodifiableListView([]),
          numberOfBuildsToDisplay: 3,
        );

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: buildResultMetric,
        ));

        final barWidgets = tester.widgetList(find.byType(BuildResultBar));

        expect(barWidgets, hasLength(equals(buildResults.length)));
      },
    );

    testWidgets(
      "displays the build result bars with the build result bar padding strategy",
      (WidgetTester tester) async {
        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        final barWidgets = tester.widgetList<BuildResultBar>(
          find.byType(BuildResultBar),
        );

        final strategies = barWidgets.map((bar) => bar.strategy);

        expect(strategies, everyElement(isNotNull));
        expect(strategies, everyElement(isA<BuildResultBarPaddingStrategy>()));
      },
    );

    testWidgets(
      "displays the build result bars with the build result bar padding strategy initialized with build results",
      (WidgetTester tester) async {
        final results = UnmodifiableListView(buildResults);
        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: results,
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        final barWidgets = tester.widgetList<BuildResultBar>(
          find.byType(BuildResultBar),
        );

        final strategies = barWidgets.map((bar) => bar.strategy.buildResults);

        expect(strategies, everyElement(equals(results)));
      },
    );

    testWidgets(
      "wraps each build result bar with constrained container having non-null min height",
      (WidgetTester tester) async {
        final results = UnmodifiableListView(buildResults);
        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: results,
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        final containers = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (widget) => widget is Container && widget.child is BuildResultBar,
          ),
        );
        final minHeights = containers.map(
          (container) => container.constraints.minHeight,
        );

        expect(minHeights, everyElement(isNotNull));
      },
    );

    testWidgets(
      "creates an empty BuildResultBars to match the numberOfBuildsToDisplay",
      (WidgetTester tester) async {
        final numberOfBars = buildResults.length + 1;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
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

        expect(emptyBuildResultBars, hasLength(missingBuildResultsCount));
      },
    );

    testWidgets(
      "applies a non-zero padding from the left to the BarGraph if there are both missing and result bars",
      (WidgetTester tester) async {
        const expectedPadding = EdgeInsets.only(left: 4.0);

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: buildResults.length + 1,
          ),
        ));

        final barGraph = tester.widget<BarGraph>(barGraphFinder);

        expect(barGraph.graphPadding, equals(expectedPadding));
      },
    );

    testWidgets(
      "applies a zero padding to the BarGraph if there are no missing bars",
      (WidgetTester tester) async {
        const expectedPadding = EdgeInsets.zero;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        final barGraph = tester.widget<BarGraph>(barGraphFinder);

        expect(barGraph.graphPadding, equals(expectedPadding));
      },
    );

    testWidgets(
      "applies a zero padding to the BarGraph if there are no result bars",
      (WidgetTester tester) async {
        const expectedPadding = EdgeInsets.zero;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView([]),
            numberOfBuildsToDisplay: buildResults.length,
          ),
        ));

        final barGraph = tester.widget<BarGraph>(barGraphFinder);

        expect(barGraph.graphPadding, equals(expectedPadding));
      },
    );

    testWidgets(
      "trims the build results from the beginning to match the given number of bars",
      (WidgetTester tester) async {
        const numberOfBars = 2;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          buildResultMetric: BuildResultMetricViewModel(
            buildResults: UnmodifiableListView(buildResults),
            numberOfBuildsToDisplay: numberOfBars,
          ),
        ));

        final trimmedData = buildResults
            .sublist(buildResults.length - numberOfBars)
            .map((barData) {
          return barData.duration.inMilliseconds;
        });

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
  /// A [BuildResultPopupViewModel] test data to test the [BuildResultBarGraph].
  static final _buildResultPopupViewModel = BuildResultPopupViewModel(
    duration: Duration.zero,
    date: DateTime.now(),
  );

  /// A list of [BuildResultViewModel] test data to test the [BuildResultBarGraph].
  static final buildResultBarTestData = [
    FinishedBuildResultViewModel(
      duration: const Duration(seconds: 5),
      date: DateTime.now(),
      buildStatus: BuildStatus.successful,
      buildResultPopupViewModel: _buildResultPopupViewModel,
    ),
    FinishedBuildResultViewModel(
      duration: const Duration(seconds: 5),
      date: DateTime.now().add(const Duration(days: 1)),
      buildStatus: BuildStatus.failed,
      buildResultPopupViewModel: _buildResultPopupViewModel,
    ),
    FinishedBuildResultViewModel(
      duration: const Duration(seconds: 5),
      date: DateTime.now().add(const Duration(days: 2)),
      buildStatus: BuildStatus.unknown,
      buildResultPopupViewModel: _buildResultPopupViewModel,
    ),
  ];

  /// A [BuildResultMetricViewModel] to display.
  final BuildResultMetricViewModel buildResultMetric;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates the [_BuildResultBarGraphTestbed] with the given [buildResultMetric].
  ///
  /// If the [theme] is not specified, an empty [MetricsThemeData] used.
  const _BuildResultBarGraphTestbed({
    Key key,
    this.buildResultMetric,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: BuildResultBarGraph(
        buildResultMetric: buildResultMetric,
      ),
    );
  }
}
