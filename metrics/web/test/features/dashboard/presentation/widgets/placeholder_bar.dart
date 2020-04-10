// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_bar.dart';

void main() {
  const _width = 2.0;
  testWidgets(
    "Displays PlaceholderBar",
    (WidgetTester tester) async {
      await tester.pumpWidget(PlaceholderBar(width: _width));

      expect(find.byType(ColoredBar), findsOneWidget);
    },
  );

  testWidgets("PlaceholderBar delegates width to the ColoredBar widget",
      (WidgetTester tester) async {
    await tester.pumpWidget(PlaceholderBar(width: _width));

    final ColoredBar coloredBar =
        tester.widget<ColoredBar>(find.byType(ColoredBar));

    expect(coloredBar.width, equals(_width));
  });

  testWidgets("Throws exception if we create PlaceholderBar without width",
      (WidgetTester tester) async {
    await tester.pumpWidget(PlaceholderBar());

    expect(tester.takeException(), isNull);
  });
}
