// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';

void main() {
  group("PlaceholderBar", () {
    const _width = 2.0;
    const color = Colors.grey;

    testWidgets(
      "can't be created with null width",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(width: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "can't be created with negative width",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(width: -2.0));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the grey color if no color given",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed());

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(Colors.grey));
      },
    );

    testWidgets(
      "applies the grey color if the null is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed());

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(Colors.grey));
      },
    );

    testWidgets(
      "displays the ColoredBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(width: _width));

        expect(find.byType(ColoredBar), findsOneWidget);
      },
    );

    testWidgets(
      "delegates the given color to the ColoredBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(
          color: color,
        ));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(color));
      },
    );

    testWidgets(
      "displays the ColoredBar with the given color borders of a 2.0 width",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(color: color));

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
        await tester.pumpWidget(_PlaceholderBarTestbed(width: _width));

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

  /// A color of this bar.
  final Color color;

  /// Creates the [_PlaceholderBarTestbed] with the given width.
  ///
  /// If the [width] is not specified, the `2.0` used.
  /// If the [color] is not specified, the [Colors.blue] used.
  const _PlaceholderBarTestbed({
    this.width = 2.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PlaceholderBar(
          width: width,
          color: color,
        ),
      ),
    );
  }
}
