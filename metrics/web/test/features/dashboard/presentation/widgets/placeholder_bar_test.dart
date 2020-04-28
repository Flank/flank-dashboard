// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_bar.dart';

void main() {
  group("PlaceholderBar", () {
    const width = 2.0;
    final inactiveColor = MetricsThemeData().inactiveWidgetTheme.primaryColor;

    testWidgets(
      "displays the ColoredBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(width: width));

        expect(find.byType(ColoredBar), findsOneWidget);
      },
    );

    testWidgets(
      "displays the ColoredBar with an inactive color",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed());

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.color, equals(inactiveColor));
      },
    );

    testWidgets(
      "displays the ColoredBar with an inactive color color borders of a 2.0 width",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed());

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(
          coloredBar.border,
          equals(Border.all(color: inactiveColor, width: 2.0)),
        );
      },
    );

    testWidgets(
      "delegates width to the ColoredBar widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_PlaceholderBarTestbed(width: width));

        final coloredBar = tester.widget<ColoredBar>(find.byType(ColoredBar));

        expect(coloredBar.width, equals(width));
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
