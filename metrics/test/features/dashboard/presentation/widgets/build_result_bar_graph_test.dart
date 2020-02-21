import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/usecases/get_build_metrics.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_bar.dart';

void main() {
  const buildResults = BuildResultBarGraphTestbed.buildResultBarTestData;

  testWidgets('Displays title text', (WidgetTester tester) async {
    const title = 'Some title';

    await tester.pumpWidget(const BuildResultBarGraphTestbed(title: title));

    expect(find.text(title), findsOneWidget);
  });

  testWidgets(
    'Applies the text style to the title',
    (WidgetTester tester) async {
      const title = 'title';
      const titleStyle = TextStyle(color: Colors.red);

      await tester.pumpWidget(const BuildResultBarGraphTestbed(
        title: title,
        titleStyle: titleStyle,
      ));

      final titleWidget = tester.widget<Text>(find.text(title));

      expect(titleWidget.style, titleStyle);
    },
  );

  testWidgets(
    "Can't create widget without title",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed(title: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create widget without data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Creates the number of bars equal to the number of given BuildResultBarData",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed());

      final barWidgets = tester.widgetList(find.descendant(
        of: find.byType(LayoutBuilder),
        matching: find.byType(ColoredBar),
      ));

      expect(barWidgets.length, buildResults.length);
    },
  );

  testWidgets(
    "Creates bars with colors from MetricsTheme corresponding to build result",
    (WidgetTester tester) async {
      const primaryColor = Colors.green;
      const errorColor = Colors.red;
      const cancelColor = Colors.yellow;

      await tester.pumpWidget(const BuildResultBarGraphTestbed(
        theme: MetricsThemeData(
          buildResultTheme: BuildResultsThemeData(
            successfulColor: primaryColor,
            failedColor: errorColor,
            canceledColor: cancelColor,
          ),
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

        switch (buildResult.result) {
          case BuildResult.successful:
            expectedBarColor = primaryColor;
            break;
          case BuildResult.canceled:
            expectedBarColor = cancelColor;
            break;
          case BuildResult.failed:
            expectedBarColor = errorColor;
            break;
        }

        expect(barWidget.color, expectedBarColor);
      }
    },
  );

  testWidgets(
    "Creates placeholder bars if the number of build results is less than the max number of build results",
    (WidgetTester tester) async {
      await tester.pumpWidget(const BuildResultBarGraphTestbed());

      final missingBuildResultsCount =
          GetBuildMetrics.maxNumberOfBuildResults - buildResults.length;

      final placeholderBuildBars = tester.widgetList(
        find.byType(PlaceholderBar),
      );

      expect(placeholderBuildBars.length, missingBuildResultsCount);
    },
  );
}

class BuildResultBarGraphTestbed extends StatelessWidget {
  static const buildResultBarTestData = [
    BuildResultBarData(
      result: BuildResult.successful,
      value: 5,
    ),
    BuildResultBarData(
      result: BuildResult.failed,
      value: 2,
    ),
    BuildResultBarData(
      result: BuildResult.canceled,
      value: 8,
    ),
  ];

  final String title;
  final TextStyle titleStyle;
  final List<BuildResultBarData> data;
  final MetricsThemeData theme;

  const BuildResultBarGraphTestbed({
    Key key,
    this.title = "Build result graph",
    this.data = buildResultBarTestData,
    this.titleStyle,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MetricsTheme(
        data: theme,
        child: Scaffold(
          body: Center(
            child: BuildResultBarGraph(
              data: data,
              title: title,
              titleStyle: titleStyle,
            ),
          ),
        ),
      ),
    );
  }
}
