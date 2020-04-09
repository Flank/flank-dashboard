// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("CirlcePercentage", () {
    final circlePercentageTypeFinder = find.byType(CirclePercentage);
    const lowPercentMaterialColor = Colors.red;
    const mediumPercentMaterialColor = Colors.yellow;
    const highPercentMaterialColor = Colors.green;
    const inactiveMaterialColor = Colors.grey;

    final MetricsThemeData theme = MetricsThemeData(
        circlePercentageLowPercentTheme: MetricWidgetThemeData(
          primaryColor: lowPercentMaterialColor[100],
          accentColor: lowPercentMaterialColor[200],
          backgroundColor: lowPercentMaterialColor[300],
        ),
        circlePercentageMediumPercentTheme: MetricWidgetThemeData(
          primaryColor: mediumPercentMaterialColor[100],
          accentColor: mediumPercentMaterialColor[200],
          backgroundColor: mediumPercentMaterialColor[300],
        ),
        circlePercentageHighPercentTheme: MetricWidgetThemeData(
          primaryColor: highPercentMaterialColor[100],
          accentColor: highPercentMaterialColor[200],
          backgroundColor: highPercentMaterialColor[300],
        ),
        inactiveWidgetTheme: MetricWidgetThemeData(
          primaryColor: inactiveMaterialColor[100],
          accentColor: inactiveMaterialColor[200],
          backgroundColor: inactiveMaterialColor[300],
        ));

    testWidgets(
      "can't be created with value more than 1.0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            value: 30.0,
          ),
        );

        expect(tester.takeException(), isA<AssertionError>());
      },
    );

    testWidgets(
      "can't be created with value less than 0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            value: -1,
          ),
        );

        expect(tester.takeException(), isA<AssertionError>());
      },
    );

    testWidgets(
      "takes given square dimensions space",
      (WidgetTester tester) async {
        const side = 20.0;
        await tester.pumpWidget(const _CirclePercentageTestbed(
          height: side,
          width: side,
        ));
        await tester.pumpAndSettle();
        final widgetSize = tester.getSize(circlePercentageTypeFinder);

        expect(widgetSize, const Size(side, side));
      },
    );

    testWidgets(
      "applies style to the percent text",
      (WidgetTester tester) async {
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            valueStyle: valueStyle,
            value: 0.3,
          ),
        );

        await tester.pumpAndSettle();

        final valueWidget = tester.firstWidget<Text>(
          find.descendant(
            of: circlePercentageTypeFinder,
            matching: find.text('30%'),
          ),
        );

        expect(valueStyle, valueWidget.style);
      },
    );

    testWidgets(
      "takes square box when parent dimensions when parent height is shorter than width",
      (WidgetTester tester) async {
        const height = 100.0;
        const width = 200.0;

        await tester.pumpWidget(const _CirclePercentageTestbed(
          height: height,
          width: width,
        ));
        await tester.pumpAndSettle();

        final widgetSize = tester.getSize(
          find.descendant(
            of: circlePercentageTypeFinder,
            matching: find.byType(CustomPaint),
          ),
        );

        expect(widgetSize.height, widgetSize.width);
      },
    );

    testWidgets(
      "takes square box when parent dimensions when parent height is shorter than width",
      (WidgetTester tester) async {
        const height = 200.0;
        const width = 100.0;

        await tester.pumpWidget(const _CirclePercentageTestbed(
          height: height,
          width: width,
        ));

        await tester.pumpAndSettle();

        final widgetSize = tester.getSize(
          find.descendant(
            of: circlePercentageTypeFinder,
            matching: find.byType(CustomPaint),
          ),
        );

        expect(widgetSize.height, widgetSize.width);
      },
    );

    testWidgets(
      "widgets with mirrored widgth/heights take same space",
      (WidgetTester tester) async {
        const height = 200.0;
        const width = 100.0;
        final percentagePaintFinder = find.descendant(
          of: circlePercentageTypeFinder,
          matching: find.byType(CustomPaint),
        );
        await tester.pumpWidget(const _CirclePercentageTestbed(
          height: height,
          width: width,
        ));
        await tester.pumpAndSettle();
        final firstWidgetSize = tester.getSize(percentagePaintFinder);

        await tester.pumpWidget(const _CirclePercentageTestbed(
          height: width,
          width: height,
        ));
        await tester.pumpAndSettle();
        final secondWidgetSize = tester.getSize(percentagePaintFinder);

        expect(firstWidgetSize, secondWidgetSize);
      },
    );

    testWidgets(
      "applies circle percentage low theme if value is in bounds from 0.1 to 0.5",
      (WidgetTester tester) async {
        await tester.pumpWidget(_CirclePercentageTestbed(
          theme: theme,
          value: 0.1,
        ));
        await tester.pumpAndSettle();

        final percentagePainter = _getPercentagePainter(tester);
        final expectedTheme = theme.circlePercentageLowPercentTheme;

        expect(percentagePainter.valueColor, expectedTheme.primaryColor);
        expect(
          percentagePainter.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(percentagePainter.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies circle percentage medium theme if value is in bounds from 0.51 to 0.79",
      (WidgetTester tester) async {
        await tester.pumpWidget(_CirclePercentageTestbed(
          theme: theme,
          value: 0.6,
        ));
        await tester.pumpAndSettle();

        final percentagePainter = _getPercentagePainter(tester);
        final expectedTheme = theme.circlePercentageMediumPercentTheme;

        expect(percentagePainter.valueColor, expectedTheme.primaryColor);
        expect(
          percentagePainter.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(percentagePainter.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies circle percentage high theme if value is grater or equals to 0.8",
      (WidgetTester tester) async {
        await tester.pumpWidget(_CirclePercentageTestbed(
          theme: theme,
          value: 0.9,
        ));
        await tester.pumpAndSettle();

        final percentagePainter = _getPercentagePainter(tester);
        final expectedTheme = theme.circlePercentageHighPercentTheme;

        expect(percentagePainter.valueColor, expectedTheme.primaryColor);
        expect(
          percentagePainter.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(percentagePainter.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies inactive theme color if value is equals to 0",
      (WidgetTester tester) async {
        await tester.pumpWidget(_CirclePercentageTestbed(
          theme: theme,
          value: 0.0,
        ));
        await tester.pumpAndSettle();

        final percentagePainter = _getPercentagePainter(tester);
        final expectedTheme = theme.inactiveWidgetTheme;

        expect(percentagePainter.valueColor, expectedTheme.primaryColor);
        expect(
          percentagePainter.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(percentagePainter.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "applies inactive theme color if value is equals to null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_CirclePercentageTestbed(
          theme: theme,
          value: null,
        ));
        await tester.pumpAndSettle();

        final percentagePainter = _getPercentagePainter(tester);
        final expectedTheme = theme.inactiveWidgetTheme;

        expect(percentagePainter.valueColor, expectedTheme.primaryColor);
        expect(
          percentagePainter.backgroundColor,
          expectedTheme.backgroundColor,
        );
        expect(percentagePainter.strokeColor, expectedTheme.accentColor);
      },
    );

    testWidgets(
      "displays 'N/A' text if the value is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _CirclePercentageTestbed(
          value: null,
        ));
        await tester.pumpAndSettle();

        expect(find.text(DashboardStrings.noDataPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "applies stroke, value and background colors",
      (WidgetTester tester) async {
        const valueColor = Colors.red;
        const strokeColor = Colors.blue;
        const backgroundColor = Colors.grey;

        await tester.pumpWidget(const _CirclePercentageTestbed(
          valueColor: valueColor,
          strokeColor: strokeColor,
          backgroundColor: backgroundColor,
        ));
        await tester.pumpAndSettle();

        final circlePercentagePaintWidget = tester.widget<CustomPaint>(
          find.descendant(
              of: find.byType(CirclePercentage),
              matching: find.byType(CustomPaint)),
        );
        final circlePercentagePainter =
            circlePercentagePaintWidget.painter as CirclePercentageChartPainter;

        expect(circlePercentagePainter.strokeColor, strokeColor);
        expect(circlePercentagePainter.valueColor, valueColor);
        expect(circlePercentagePainter.backgroundColor, backgroundColor);
      },
    );
  });
}

CirclePercentageChartPainter _getPercentagePainter(WidgetTester tester) {
  final customPaintWidget = tester.widget<CustomPaint>(find.descendant(
    of: find.byType(CirclePercentage),
    matching: find.byType(CustomPaint),
  ));

  final percentagePainter =
      customPaintWidget.painter as CirclePercentageChartPainter;
  return percentagePainter;
}

class _CirclePercentageTestbed extends StatelessWidget {
  final double value;
  final EdgeInsets padding;
  final double strokeWidth;
  final Color valueColor;
  final Color strokeColor;
  final Color backgroundColor;
  final AlignmentGeometry alignment;
  final double height;
  final double width;
  final TextStyle valueStyle;
  final MetricsThemeData theme;

  const _CirclePercentageTestbed({
    Key key,
    this.value = 0.3,
    this.height,
    this.strokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    this.valueColor,
    this.strokeColor,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.theme = const MetricsThemeData(),
    this.valueStyle,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      metricsThemeData: theme,
      body: Align(
        alignment: alignment,
        child: Container(
          height: height,
          width: width,
          child: CirclePercentage(
            value: value,
            strokeWidth: strokeWidth,
            valueColor: valueColor,
            strokeColor: strokeColor,
            padding: padding,
            valueStyle: valueStyle,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }
}
