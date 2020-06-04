import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/graphs/bar_graph.dart';
import 'package:metrics/common/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/common/presentation/graphs/placeholder_bar.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("BuildResultBarGraph", () {
    const buildResults = _BuildResultBarGraphTestbed.buildResultBarTestData;

    testWidgets(
      "can't create widget without data",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BuildResultBarGraphTestbed(data: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "creates the number of bars equal to the number of given BuildResultBarData",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BuildResultBarGraphTestbed());

        final barWidgets = tester.widgetList(find.descendant(
          of: find.byType(LayoutBuilder),
          matching: find.byType(ColoredBar),
        ));

        expect(barWidgets.length, buildResults.length);
      },
    );

    testWidgets(
      "creates bars with colors from MetricsTheme corresponding to build status",
      (WidgetTester tester) async {
        const primaryColor = Colors.green;
        const errorColor = Colors.red;

        const themeData = BuildResultsThemeData(
          successfulColor: primaryColor,
          failedColor: errorColor,
          canceledColor: errorColor,
        );
        await tester.pumpWidget(const _BuildResultBarGraphTestbed(
          theme: MetricsThemeData(
            buildResultTheme: themeData,
          ),
        ));

        final barWidgets = tester
            .widgetList<ColoredBar>(find.descendant(
              of: find.byType(LayoutBuilder),
              matching: find.byType(ColoredBar),
            ))
            .toList();

        for (int i = 0; i < buildResults.length; i++) {
          final barWidget = barWidgets[i];
          final buildResult = buildResults[i];

          Color expectedBarColor;

          switch (buildResult.buildStatus) {
            case BuildStatus.successful:
              expectedBarColor = themeData.successfulColor;
              break;
            case BuildStatus.cancelled:
              expectedBarColor = themeData.canceledColor;
              break;
            case BuildStatus.failed:
              expectedBarColor = themeData.failedColor;
              break;
          }

          expect(barWidget.color, expectedBarColor);
        }
      },
    );

    testWidgets(
      "creates placeholder bars if the number of build results is less than the max number of build results",
      (WidgetTester tester) async {
        final numberOfBars = buildResults.length + 1;

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          data: BuildResultMetricViewModel(
            buildResults: _BuildResultBarGraphTestbed.buildResultBarTestData,
            numberOfBuildsToDisplay: numberOfBars,
          ),
        ));

        final missingBuildResultsCount = numberOfBars - buildResults.length;

        final placeholderBuildBars = tester.widgetList(
          find.byType(PlaceholderBar),
        );

        expect(placeholderBuildBars.length, missingBuildResultsCount);
      },
    );

    testWidgets(
      "trims the bars data from the begging to match the given number of bars",
      (WidgetTester tester) async {
        const numberOfBars = 2;

        await tester.pumpWidget(const _BuildResultBarGraphTestbed(
          data: BuildResultMetricViewModel(
            buildResults: _BuildResultBarGraphTestbed.buildResultBarTestData,
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

        expect(barGraphData.length, numberOfBars);

        expect(barGraphData, equals(trimmedData));
      },
    );

    testWidgets(
      "shows the placeholder bar if the build result status is null",
      (WidgetTester tester) async {
        const testData = [
          BuildResultViewModel(
            value: 20,
          )
        ];

        await tester.pumpWidget(_BuildResultBarGraphTestbed(
          data: BuildResultMetricViewModel(
            buildResults: testData,
            numberOfBuildsToDisplay: testData.length,
          ),
        ));

        expect(find.byType(PlaceholderBar), findsOneWidget);
      },
    );
  });
}

class _BuildResultBarGraphTestbed extends StatelessWidget {
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

  static const buildResultMetric = BuildResultMetricViewModel(
      buildResults: buildResultBarTestData, numberOfBuildsToDisplay: 3);

  final BuildResultMetricViewModel data;
  final MetricsThemeData theme;

  const _BuildResultBarGraphTestbed({
    Key key,
    this.data = buildResultMetric,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: BuildResultBarGraph(
        data: data,
      ),
    );
  }
}
