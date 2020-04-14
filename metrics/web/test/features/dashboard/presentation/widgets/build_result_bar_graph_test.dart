import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_bar.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  const buildResults = _BuildResultBarGraphTestbed.buildResultBarTestData;

  testWidgets(
    "Can't create widget without data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _BuildResultBarGraphTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Creates the number of bars equal to the number of given BuildResultBarData",
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
    "Creates bars with colors from MetricsTheme corresponding to build status",
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
    "Creates placeholder bars if the number of build results is less than the max number of build results",
    (WidgetTester tester) async {
      final numberOfBars = buildResults.length + 1;

      await tester.pumpWidget(_BuildResultBarGraphTestbed(
        numberOfBars: numberOfBars,
      ));

      final missingBuildResultsCount = numberOfBars - buildResults.length;

      final placeholderBuildBars = tester.widgetList(
        find.byType(PlaceholderBar),
      );

      expect(placeholderBuildBars.length, missingBuildResultsCount);
    },
  );

  testWidgets(
    "Trims the bars data from the begging to match the given number of bars",
    (WidgetTester tester) async {
      const numberOfBars = 2;

      await tester.pumpWidget(const _BuildResultBarGraphTestbed(
        numberOfBars: numberOfBars,
      ));

      final trimmedData =
          buildResults.sublist(buildResults.length - numberOfBars);

      final barGraphWidget = tester.widget<BarGraph>(find.byWidgetPredicate(
        (widget) => widget is BarGraph,
      ));

      final barGraphData = barGraphWidget.data;

      expect(barGraphData.length, numberOfBars);

      expect(barGraphData, equals(trimmedData));
    },
  );

  testWidgets(
    "Shows the placeholder bar if the build result status is null",
    (WidgetTester tester) async {
      const testData = [
        BuildResultBarData(
          value: 20,
        )
      ];

      await tester.pumpWidget(_BuildResultBarGraphTestbed(
        data: testData,
        numberOfBars: testData.length,
      ));

      expect(find.byType(PlaceholderBar), findsOneWidget);
    },
  );
}

class _BuildResultBarGraphTestbed extends StatelessWidget {
  static const buildResultBarTestData = [
    BuildResultBarData(
      buildStatus: BuildStatus.successful,
      value: 5,
    ),
    BuildResultBarData(
      buildStatus: BuildStatus.failed,
      value: 2,
    ),
    BuildResultBarData(
      buildStatus: BuildStatus.cancelled,
      value: 8,
    ),
  ];

  final List<BuildResultBarData> data;
  final MetricsThemeData theme;
  final int numberOfBars;

  const _BuildResultBarGraphTestbed({
    Key key,
    this.data = buildResultBarTestData,
    this.theme = const MetricsThemeData(),
    this.numberOfBars = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: BuildResultBarGraph(
        data: data,
        numberOfBars: numberOfBars,
      ),
    );
  }
}
