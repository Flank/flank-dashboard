import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ColoredBar", () {
    testWidgets(
      "applies the color of the bar",
      (WidgetTester tester) async {
        const color = Colors.red;

        await tester.pumpWidget(const _ColoredBarTestbed(color: color));

        final barContainer = tester.widget<Container>(find.descendant(
          of: find.byType(ColoredBar),
          matching: find.byType(Container),
        ));

        final barContainerDecoration = barContainer.decoration as BoxDecoration;

        expect(barContainerDecoration.color, color);
      },
    );

    testWidgets(
      "applies the padding to the bar",
      (WidgetTester tester) async {
        const padding = EdgeInsets.all(32.0);

        await tester.pumpWidget(const _ColoredBarTestbed(padding: padding));

        final barPadding = tester.widget<Padding>(find.descendant(
          of: find.byType(ColoredBar),
          matching: find.byType(Padding),
        ));

        expect(barPadding.padding, padding);
      },
    );

    testWidgets(
      "applies the border to the bar",
      (WidgetTester tester) async {
        final border = Border.all(color: Colors.red);

        await tester.pumpWidget(_ColoredBarTestbed(
          border: border,
        ));

        final barContainer = tester.widget<Container>(find.descendant(
          of: find.byType(ColoredBar),
          matching: find.byType(Container),
        ));

        final barContainerDecoration = barContainer.decoration as BoxDecoration;

        expect(barContainerDecoration.border, border);
      },
    );

    testWidgets(
      "applies the border radius to the bar",
      (WidgetTester tester) async {
        final borderRadius = BorderRadius.circular(32.0);

        await tester.pumpWidget(_ColoredBarTestbed(
          borderRadius: borderRadius,
        ));

        final barContainer = tester.widget<Container>(find.descendant(
          of: find.byType(ColoredBar),
          matching: find.byType(Container),
        ));

        final barContainerDecoration = barContainer.decoration as BoxDecoration;

        expect(barContainerDecoration.borderRadius, borderRadius);
      },
    );

    testWidgets(
      "applies the width of the bar",
      (WidgetTester tester) async {
        const width = 4.0;

        await tester.pumpWidget(const _ColoredBarTestbed(
          width: width,
        ));

        final barContainer = tester.widget<Container>(find.descendant(
          of: find.byType(ColoredBar),
          matching: find.byType(Container),
        ));

        final barConstraints = barContainer.constraints;

        expect(barConstraints.maxWidth, width);
        expect(barConstraints.minWidth, width);
      },
    );
  });
}

/// A testbed class required to test the [ColoredBar] widget.
class _ColoredBarTestbed extends StatelessWidget {
  /// The color of the [ColoredBar].
  final Color color;

  /// The radius of the border of the [ColoredBar].
  final BorderRadiusGeometry borderRadius;

  /// The border decoration of the [ColoredBar].
  final Border border;

  /// The padding to inset the [ColoredBar].
  final EdgeInsets padding;

  /// The width of the [ColoredBar].
  final double width;

  /// Creates the instance of this testbed.
  ///
  /// The [padding] defaults to [EdgeInsets.all] with parameter `4.0`.
  const _ColoredBarTestbed({
    Key key,
    this.color,
    this.borderRadius,
    this.border,
    this.padding = const EdgeInsets.all(4.0),
    this.width = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: Center(
        child: ColoredBar(
          color: color,
          padding: padding,
          border: border,
          borderRadius: borderRadius,
          width: width,
        ),
      ),
    );
  }
}
