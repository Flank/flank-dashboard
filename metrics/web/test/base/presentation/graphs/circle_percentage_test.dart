// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("CirclePercentage", () {
    final circlePercentageTypeFinder = find.byType(CirclePercentage);
    const strokeColor = Colors.blue;
    const valueColor = Colors.red;

    testWidgets(
      "shows the 100% value if the given value more than 1",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            value: 30.0,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("100%"), findsOneWidget);
      },
    );

    testWidgets(
      "shows the 0% value if the given value less than 0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            value: -1,
          ),
        );

        expect(find.text("0%"), findsOneWidget);
      },
    );

    testWidgets("can be created with null stroke color", (tester) async {
      await tester.pumpWidget(
        const _CirclePercentageTestbed(
          strokeColor: null,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets("can be created with null value color", (tester) async {
      await tester.pumpWidget(
        const _CirclePercentageTestbed(
          valueColor: null,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
      "can be created with null placeholder and value",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _CirclePercentageTestbed(
          value: null,
          placeholder: null,
        ));

        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "can be created without stroke color",
      (tester) async {
        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            value: 0.5,
            valueColor: Colors.blue,
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "can be created without value color",
      (tester) async {
        await tester.pumpWidget(
          const _CirclePercentageTestbed(
            value: 0.5,
            strokeColor: Colors.blue,
          ),
        );

        expect(tester.takeException(), isNull);
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
      "takes square box dimensions when parent height is shorter than the width",
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
      "widgets with mirrored width/heights take same space",
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
      "displays the given placeholder if the value is null",
      (WidgetTester tester) async {
        const placeholderText = 'placeholder';

        await tester.pumpWidget(const _CirclePercentageTestbed(
          value: null,
          placeholder: Text(placeholderText),
        ));
        await tester.pumpAndSettle();

        expect(find.text(placeholderText), findsOneWidget);
      },
    );

    testWidgets(
      "applies background color",
      (WidgetTester tester) async {
        const backgroundColor = Colors.grey;

        await tester.pumpWidget(const _CirclePercentageTestbed(
          backgroundColor: backgroundColor,
        ));
        await tester.pumpAndSettle();

        final circlePercentagePainter = _getCirclePercentagePainter(tester);

        expect(circlePercentagePainter.backgroundColor, backgroundColor);
      },
    );

    testWidgets(
      "applies value color",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _CirclePercentageTestbed(
          valueColor: valueColor,
        ));
        await tester.pumpAndSettle();

        final circlePercentagePainter = _getCirclePercentagePainter(tester);

        expect(circlePercentagePainter.valueColor, valueColor);
      },
    );

    testWidgets(
      "resets the animation if the value changes to null",
      (WidgetTester tester) async {
        final valueNotifier = ValueNotifier(0.5);

        await tester.pumpWidget(ValueListenableBuilder<double>(
          valueListenable: valueNotifier,
          builder: (_, value, __) {
            return _CirclePercentageTestbed(
              value: value,
            );
          },
        ));
        await tester.pumpAndSettle();

        valueNotifier.value = null;

        await tester.pumpAndSettle();

        final animatedBuilder = tester.widget<AnimatedBuilder>(find.descendant(
          of: find.byType(AspectRatio),
          matching: find.byType(AnimatedBuilder),
        ));

        final animation = animatedBuilder.listenable as Animation;

        expect(animation.value, equals(0.0));
      },
    );

    testWidgets(
      "applies stroke color",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _CirclePercentageTestbed(
          strokeColor: strokeColor,
        ));
        await tester.pumpAndSettle();

        final circlePercentagePainter = _getCirclePercentagePainter(tester);

        expect(circlePercentagePainter.strokeColor, strokeColor);
      },
    );

    testWidgets(
      "displays a single line text containing the value",
      (WidgetTester tester) async {
        const value = 0.4;
        final valueText = '${(value * 100).toInt()}%';
        final valueTextFinder = find.text(valueText);

        await tester.pumpWidget(const _CirclePercentageTestbed(
          value: value,
        ));
        await tester.pumpAndSettle();

        final valueTextWidget = tester.widget<Text>(valueTextFinder);

        expect(valueTextWidget.maxLines, equals(1));
      },
    );

    testWidgets(
      "contains the center-aligned percent text inside the circle percentage graph",
      (WidgetTester tester) async {
        const strokeWidth = 7.0;
        const value = 1.0;
        final valueText = '${(value * 100).toInt()}%';

        await tester.pumpWidget(const _CirclePercentageTestbed(
          strokeWidth: strokeWidth,
          value: value,
        ));
        await tester.pumpAndSettle();

        final percentageFinder = find.descendant(
          of: find.byType(CirclePercentage),
          matching: find.byType(CustomPaint),
        );
        final valueTextFinder = find.text(valueText);

        final percentageCenter = tester.getCenter(percentageFinder);
        final percentagePainterSize = tester.getSize(percentageFinder);

        final valueTextCenter = tester.getCenter(valueTextFinder);
        final valueTextSize = tester.getSize(valueTextFinder);

        final circlePercentageDiameter = min(
          percentagePainterSize.width,
          percentagePainterSize.height,
        );
        final innerCircleDiameter = circlePercentageDiameter - strokeWidth;

        expect(valueTextCenter, equals(percentageCenter));
        expect(valueTextSize.width, lessThanOrEqualTo(innerCircleDiameter));
        expect(valueTextSize.height, lessThanOrEqualTo(innerCircleDiameter));
      },
    );
  });
}

CirclePercentageChartPainter _getCirclePercentagePainter(WidgetTester tester) {
  final circlePercentagePaintWidget = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(CirclePercentage),
      matching: find.byType(CustomPaint),
    ),
  );

  return circlePercentagePaintWidget.painter as CirclePercentageChartPainter;
}

/// A testbed class required to test the [CirclePercentage] widget.
class _CirclePercentageTestbed extends StatelessWidget {
  /// A percent [value] to display.
  final double value;

  /// The padding of the [value] text inside the circle graph.
  final EdgeInsets padding;

  /// The wight of the graph's stroke. Defaults to 2.0.
  final double strokeWidth;

  /// The color of the part of the graph that represents the value.
  final Color valueColor;

  /// The color of the graph's circle itself.
  final Color strokeColor;

  /// The color to fill the graph with.
  final Color backgroundColor;

  /// The graph alignment
  final AlignmentGeometry alignment;

  /// The graph container height
  final double height;

  /// The graph container width.
  final double width;

  /// The [TextStyle] of the percent text.
  final TextStyle valueStyle;

  /// The [MetricsThemeData] used in testbed.
  final MetricsThemeData theme;

  /// The [Widget] to display if there is no [value] provided.
  final Widget placeholder;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [value] defaults to the `0.3`.
  /// The [strokeWidth] defaults to the `5.0`.
  /// The [padding] defaults to the [EdgeInsets.zero].
  /// The [alignment] defaults to the [Alignment.center].
  /// The [theme] defaults to the [MetricsThemeData].
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
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: Align(
        alignment: alignment,
        child: SizedBox(
          height: height,
          width: width,
          child: CirclePercentage(
            value: value,
            placeholder: placeholder ?? Container(),
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
