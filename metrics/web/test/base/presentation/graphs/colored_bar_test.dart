// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ColoredBar", () {
    testWidgets("throws if the given width is null", (tester) async {
      await tester.pumpWidget(const _ColoredBarTestbed(width: null));

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets("throws if the given width is negative", (tester) async {
      await tester.pumpWidget(const _ColoredBarTestbed(width: -1.0));

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets("applies the color to the bar", (tester) async {
      const color = Colors.red;

      await tester.pumpWidget(const _ColoredBarTestbed(color: color));

      final barContainerDecoration = FinderUtil.findBoxDecoration(tester);

      expect(barContainerDecoration.color, equals(color));
    });

    testWidgets("applies the padding to the bar", (tester) async {
      const padding = EdgeInsets.all(32.0);

      await tester.pumpWidget(const _ColoredBarTestbed(padding: padding));

      final barPadding = tester.widget<Padding>(find.descendant(
        of: find.byType(ColoredBar),
        matching: find.byType(Padding),
      ));

      expect(barPadding.padding, equals(padding));
    });

    testWidgets("applies the border to the bar", (tester) async {
      final border = Border.all(color: Colors.red);

      await tester.pumpWidget(_ColoredBarTestbed(
        border: border,
      ));

      final barContainerDecoration = FinderUtil.findBoxDecoration(tester);

      expect(barContainerDecoration.border, equals(border));
    });

    testWidgets("applies the border radius to the bar", (tester) async {
      final borderRadius = BorderRadius.circular(32.0);

      await tester.pumpWidget(_ColoredBarTestbed(
        borderRadius: borderRadius,
      ));

      final barContainerDecoration = FinderUtil.findBoxDecoration(tester);

      expect(barContainerDecoration.borderRadius, equals(borderRadius));
    });

    testWidgets("applies the width to the bar", (tester) async {
      const width = 4.0;

      await tester.pumpWidget(const _ColoredBarTestbed(
        width: width,
      ));

      final barContainer = tester.widget<DecoratedContainer>(find.descendant(
        of: find.byType(ColoredBar),
        matching: find.byType(DecoratedContainer),
      ));

      expect(barContainer.width, equals(width));
    });

    testWidgets("applies the height to the bar", (tester) async {
      const height = 4.0;

      await tester.pumpWidget(const _ColoredBarTestbed(
        height: height,
      ));

      final barContainer = tester.widget<DecoratedContainer>(find.descendant(
        of: find.byType(ColoredBar),
        matching: find.byType(DecoratedContainer),
      ));

      expect(barContainer.height, equals(height));
    });
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

  /// The height of the [ColoredBar].
  final double height;

  /// Creates the instance of this testbed.
  ///
  /// The [padding] defaults to [EdgeInsets.all] with parameter `4.0`.
  /// The [width] defaults to the `1.0`.
  const _ColoredBarTestbed({
    Key key,
    this.color,
    this.borderRadius,
    this.border,
    this.padding = const EdgeInsets.all(4.0),
    this.width = 1.0,
    this.height,
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
          height: height,
        ),
      ),
    );
  }
}
