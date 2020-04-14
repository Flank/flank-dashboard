import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  testWidgets(
    "Applies the color of the bar",
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
    "Applies the padding to the bar",
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
    "Applies the border decoration to the bar",
    (WidgetTester tester) async {
      final border = Border.all(color: Colors.red);
      final borderRadius = BorderRadius.circular(32.0);

      await tester.pumpWidget(_ColoredBarTestbed(
        borderRadius: borderRadius,
        border: border,
      ));

      final barContainer = tester.widget<Container>(find.descendant(
        of: find.byType(ColoredBar),
        matching: find.byType(Container),
      ));

      final barContainerDecoration = barContainer.decoration as BoxDecoration;

      expect(barContainerDecoration.border, border);
      expect(barContainerDecoration.borderRadius, borderRadius);
    },
  );

  testWidgets(
    "Applies the width of the bar",
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
}

class _ColoredBarTestbed extends StatelessWidget {
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final Border border;
  final EdgeInsets padding;
  final double width;

  const _ColoredBarTestbed({
    Key key,
    this.color,
    this.borderRadius,
    this.border,
    this.padding = const EdgeInsets.all(4.0),
    this.width,
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
