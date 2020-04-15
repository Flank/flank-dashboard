// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_bar.dart';

void main() {
  const _width = 2.0;

  group("PlaceholderBar", () {
    testWidgets(
      "displays the ColoredBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(width: _width));

        expect(find.byType(ColoredBar), findsOneWidget);
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

class _PlaceholderBarTestbed extends StatelessWidget {
  final double width;

  const _PlaceholderBarTestbed({
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PlaceholderBar(
          width: width,
        ),
      ),
    );
  }
}
