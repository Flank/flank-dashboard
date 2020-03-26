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
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';

void main() {
  group("Widget configuration", () {
    testWidgets(
      "Can't create widget with value more than 1.0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const CirclePercentageTestbed(
            title: "Coverage",
            value: 30.0,
          ),
        );

        expect(tester.takeException(), isA<AssertionError>());
      },
    );

    testWidgets(
      "Can't create widget with value less than 0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const CirclePercentageTestbed(
            title: "Coverage",
            value: -1,
          ),
        );

        expect(tester.takeException(), isA<AssertionError>());
      },
    );
  });

  group("Data loading", () {
    testWidgets(
      "Shows the coverage label",
      (WidgetTester tester) async {
        await tester.pumpWidget(const CirclePercentageTestbed());
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(CirclePercentage, 'Coverage'),
          findsOneWidget,
        );
      },
    );
  });

  group("Data display", () {
    final circlePercentageTypeFinder = find.byType(CirclePercentage);
    testWidgets(
      "Takes given square dimensions space",
      (WidgetTester tester) async {
        const side = 20.0;
        await tester.pumpWidget(const CirclePercentageTestbed(
          height: side,
          width: side,
        ));
        await tester.pumpAndSettle();
        final widgetSize = tester.getSize(circlePercentageTypeFinder);

        expect(widgetSize, const Size(side, side));
      },
    );

    testWidgets(
      "Applies styles to the title and percent texts",
      (WidgetTester tester) async {
        const titleStyle = TextStyle(fontWeight: FontWeight.bold);
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(
          const CirclePercentageTestbed(
            title: 'Coverage',
            titleStyle: titleStyle,
            valueStyle: valueStyle,
            value: 0.3,
          ),
        );

        await tester.pumpAndSettle();

        final titleWidget = tester.firstWidget<Text>(
          find.descendant(
            of: circlePercentageTypeFinder,
            matching: find.text('Coverage'),
          ),
        );

        final valueWidget = tester.firstWidget<Text>(
          find.descendant(
            of: circlePercentageTypeFinder,
            matching: find.text('30%'),
          ),
        );

        expect(titleStyle, titleWidget.style);
        expect(valueStyle, valueWidget.style);
      },
    );

    testWidgets(
      "Takes square box when parent dimensions when parent height is shorter than width",
      (WidgetTester tester) async {
        const height = 100.0;
        const width = 200.0;

        await tester.pumpWidget(const CirclePercentageTestbed(
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
      "Takes square box when parent dimensions when parent height is shorter than width",
      (WidgetTester tester) async {
        const height = 200.0;
        const width = 100.0;

        await tester.pumpWidget(const CirclePercentageTestbed(
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
      "Widgets with mirrored widgth/heights take same space",
      (WidgetTester tester) async {
        const height = 200.0;
        const width = 100.0;
        final percentagePaintFinder = find.descendant(
          of: circlePercentageTypeFinder,
          matching: find.byType(CustomPaint),
        );
        await tester.pumpWidget(const CirclePercentageTestbed(
          height: height,
          width: width,
        ));
        await tester.pumpAndSettle();
        final firstWidgetSize = tester.getSize(percentagePaintFinder);

        await tester.pumpWidget(const CirclePercentageTestbed(
          height: width,
          width: height,
        ));
        await tester.pumpAndSettle();
        final secondWidgetSize = tester.getSize(percentagePaintFinder);

        expect(firstWidgetSize, secondWidgetSize);
      },
    );

    testWidgets(
      "Applies colors from the theme",
      (WidgetTester tester) async {
        const primaryColor = Colors.green;
        const accentColor = Colors.red;
        const backgroundColor = Colors.orange;

        const theme = MetricsThemeData(
          circlePercentagePrimaryTheme: MetricWidgetThemeData(
            primaryColor: primaryColor,
            accentColor: accentColor,
            backgroundColor: backgroundColor,
          ),
        );

        await tester.pumpWidget(const CirclePercentageTestbed(theme: theme));
        await tester.pumpAndSettle();

        final customPaintWidget = tester.widget<CustomPaint>(find.descendant(
          of: find.byType(CirclePercentage),
          matching: find.byType(CustomPaint),
        ));

        final percentagePainter =
            customPaintWidget.painter as CirclePercentageChartPainter;

        expect(percentagePainter.valueColor, primaryColor);
        expect(percentagePainter.backgroundColor, backgroundColor);
        expect(percentagePainter.strokeColor, accentColor);
      },
    );

    testWidgets(
      "Applies stroke, value and background colors",
      (WidgetTester tester) async {
        const valueColor = Colors.red;
        const strokeColor = Colors.blue;
        const backgroundColor = Colors.grey;

        await tester.pumpWidget(const CirclePercentageTestbed(
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

class CirclePercentageTestbed extends StatelessWidget {
  final String title;
  final double value;
  final EdgeInsets padding;
  final double strokeWidth;
  final Color valueColor;
  final Color strokeColor;
  final Color backgroundColor;
  final AlignmentGeometry alignment;
  final double height;
  final double width;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final MetricsThemeData theme;

  const CirclePercentageTestbed({
    Key key,
    this.value = 0.3,
    this.title = 'Coverage',
    this.height,
    this.strokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    this.valueColor,
    this.strokeColor,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.theme = const MetricsThemeData(),
    this.titleStyle,
    this.valueStyle,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsTheme(
          data: theme,
          child: Align(
            alignment: alignment,
            child: Container(
              height: height,
              width: width,
              child: CirclePercentage(
                title: title,
                value: value,
                strokeWidth: strokeWidth,
                valueColor: valueColor,
                strokeColor: strokeColor,
                padding: padding,
                titleStyle: titleStyle,
                valueStyle: valueStyle,
                backgroundColor: backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
