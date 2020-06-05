import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';

void main() {
  group("MetricsTextPlaceholder", () {
    const text = 'text';

    testWidgets("displays the given text", (tester) async {
      await tester.pumpWidget(const _MetricsTextPlaceholderTestbed(text: text));

      expect(find.text(text), findsOneWidget);
    });

    testWidgets("has a grey text color as a default", (tester) async {
      await tester.pumpWidget(const _MetricsTextPlaceholderTestbed(text: text));

      final placeholder = tester.widget<MetricsTextPlaceholder>(
        find.byType(MetricsTextPlaceholder),
      );

      expect(placeholder.color, equals(Colors.grey));
    });

    testWidgets("has a text size equals to 20.0 as a default", (tester) async {
      await tester.pumpWidget(const _MetricsTextPlaceholderTestbed(text: text));

      final placeholder = tester.widget<MetricsTextPlaceholder>(
        find.byType(MetricsTextPlaceholder),
      );

      expect(placeholder.size, equals(20.0));
    });
  });
}

/// A testbed widget, used to test the [MetricsTextPlaceholder] widget.
class _MetricsTextPlaceholderTestbed extends StatelessWidget {
  final String text;

  const _MetricsTextPlaceholderTestbed({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsTextPlaceholder(
          text: text,
        ),
      ),
    );
  }
}
