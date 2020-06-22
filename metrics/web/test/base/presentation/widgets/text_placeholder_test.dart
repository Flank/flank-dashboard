import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/text_placeholder.dart';

void main() {
  group("TextPlaceholder", () {
    const text = 'placeholder text';

    testWidgets(
      "throws an AssertionError if the given text is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextPlaceholderTestbed(text: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextPlaceholderTestbed(text: text));

        final placeholderWithText = find.descendant(
          of: find.byType(TextPlaceholder),
          matching: find.text(text),
        );

        expect(placeholderWithText, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given size to the given text",
      (WidgetTester tester) async {
        const size = 10.0;

        await tester.pumpWidget(
          const _TextPlaceholderTestbed(text: text, size: size),
        );

        final widget = tester.widget<Text>(
          find.descendant(
            of: find.byType(TextPlaceholder),
            matching: find.text(text),
          ),
        );

        expect(widget.style.fontSize, equals(size));
      },
    );

    testWidgets(
      "applies the given color to the given text",
      (WidgetTester tester) async {
        const color = Colors.red;

        await tester.pumpWidget(
          const _TextPlaceholderTestbed(text: text, color: color),
        );

        final widget = tester.widget<Text>(
          find.descendant(
            of: find.byType(TextPlaceholder),
            matching: find.text(text),
          ),
        );

        expect(widget.style.color, equals(color));
      },
    );
  });
}

/// A testbed class required to test the [TextPlaceholder] widget.
class _TextPlaceholderTestbed extends StatelessWidget {
  /// A text to display.
  final String text;

  /// A size of the given [text].
  final double size;

  /// A color of the given [text].
  final Color color;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [size] default value is 20.0.
  /// The [color] default value is [Colors.grey].
  const _TextPlaceholderTestbed({
    Key key,
    this.text,
    this.size = 20.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextPlaceholder(
          text: text,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
