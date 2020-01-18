// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';

void main() {
  group("Widget configuration", () {
    testWidgets(
      "Can't create widget with value more than 1.0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          CirclePercentageTestbed(
            title: "Coverage",
            value: 30.0,
          ),
        );

        expect(tester.takeException(), isInstanceOf<AssertionError>());
      },
    );

    testWidgets(
      "Can't create widget with value less than 0",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          CirclePercentageTestbed(
            title: "Coverage",
            value: -1,
          ),
        );

        expect(tester.takeException(), isInstanceOf<AssertionError>());
      },
    );
  });

  group("Data loading", () {
    testWidgets(
      "Shows the coverage label",
      (WidgetTester tester) async {
        await tester.pumpWidget(CirclePercentageTestbed());
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
        final side = 20.0;
        await tester.pumpWidget(CirclePercentageTestbed(
          height: side,
          width: side,
        ));
        await tester.pumpAndSettle();
        final widgetSize = await tester.getSize(circlePercentageTypeFinder);

        expect(widgetSize, Size(side, side));
      },
    );

    testWidgets(
      "Applies styles to the title and percent texts",
      (WidgetTester tester) async {
        final titleStyle = TextStyle(fontWeight: FontWeight.bold);
        final valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(
          CirclePercentageTestbed(
            title: 'Coverage',
            titleStyle: titleStyle,
            valueStyle: valueStyle,
            value: 0.3,
          ),
        );

        await tester.pumpAndSettle();

        final titleWidget = await tester.firstWidget<Text>(
          find.descendant(
            of: circlePercentageTypeFinder,
            matching: find.text('Coverage'),
          ),
        );

        final valueWidget = await tester.firstWidget<Text>(
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
        final height = 100.0;
        final width = 200.0;

        await tester.pumpWidget(CirclePercentageTestbed(
          height: height,
          width: width,
        ));

        await tester.pumpAndSettle();

        final widgetSize = await tester.getSize(
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
        final height = 200.0;
        final width = 100.0;

        await tester.pumpWidget(CirclePercentageTestbed(
          height: height,
          width: width,
        ));

        await tester.pumpAndSettle();

        final widgetSize = await tester.getSize(
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
        final height = 200.0;
        final width = 100.0;
        final percentagePaintFinder = find.descendant(
          of: circlePercentageTypeFinder,
          matching: find.byType(CustomPaint),
        );
        await tester.pumpWidget(CirclePercentageTestbed(
          height: height,
          width: width,
        ));
        await tester.pumpAndSettle();
        final firstWidgetSize = await tester.getSize(percentagePaintFinder);

        await tester.pumpWidget(CirclePercentageTestbed(
          height: width,
          width: height,
        ));
        await tester.pumpAndSettle();
        final secondWidgetSize = tester.getSize(percentagePaintFinder);

        expect(firstWidgetSize, secondWidgetSize);
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
  final AlignmentGeometry alignment;
  final double height;
  final double width;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  const CirclePercentageTestbed({
    Key key,
    this.value = 0.3,
    this.title = 'Coverage',
    this.height,
    this.strokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    this.valueColor = Colors.blue,
    this.strokeColor = Colors.grey,
    this.alignment = Alignment.center,
    this.titleStyle,
    this.valueStyle,
    this.width,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
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
            ),
          ),
        ),
      ),
    );
  }
}
