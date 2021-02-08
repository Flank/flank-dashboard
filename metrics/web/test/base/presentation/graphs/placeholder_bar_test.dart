// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("PlaceholderBar", () {
    const _width = 2.0;
    const color = Colors.grey;

    testWidgets(
      "throws an AssertionError if the given width is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(width: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given width is negative",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(width: -2.0));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given height is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(height: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given height is negative",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(height: -2.0));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the grey color if color is not specified",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed());

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(Colors.grey));
      },
    );

    testWidgets(
      "applies the grey color if the given color is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(color: null));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(Colors.grey));
      },
    );

    testWidgets(
      "displays the ColoredBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(width: _width));

        expect(find.byType(ColoredBar), findsOneWidget);
      },
    );

    testWidgets(
      "delegates the given color to the ColoredBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(
          color: color,
        ));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(color));
      },
    );

    testWidgets(
      "displays the colored bar with the borders of the given color and default width",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(color: color));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(
          coloredBar.border,
          equals(Border.all(color: color, width: 2.0)),
        );
      },
    );

    testWidgets(
      "delegates width to the ColoredBar widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderBarTestbed(width: _width));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.width, equals(_width));
      },
    );
  });
}

/// A testbed class required for testing the [PlaceholderBar].
class _PlaceholderBarTestbed extends StatelessWidget {
  /// A with of this bar.
  final double width;

  /// A height of this bar.
  final double height;

  /// A color of this bar.
  final Color color;

  /// Creates the [_PlaceholderBarTestbed] with the given width.
  ///
  /// If the [width] is not specified, the `1.0` used.
  /// If the [height] is not specified, the `1.0` used.
  const _PlaceholderBarTestbed({
    this.width = 1.0,
    this.height = 1.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PlaceholderBar(
          width: width,
          height: height,
          color: color,
        ),
      ),
    );
  }
}
