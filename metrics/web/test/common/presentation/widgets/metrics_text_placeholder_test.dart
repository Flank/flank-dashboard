import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/text_placeholder.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTextPlaceholder", () {
    const text = 'text';

    testWidgets(
      "throws an AssertionError if a text is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsTextPlaceholderTestbed());

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given text to the text placeholder",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsTextPlaceholderTestbed(text: text),
        );

        expect(find.widgetWithText(TextPlaceholder, text), findsOneWidget);
      },
    );

    testWidgets(
      "applies the text style from the metrics inactive widget theme to the text placeholder",
      (WidgetTester tester) async {
        const textStyle = TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );

        const theme = MetricsThemeData(
          inactiveWidgetTheme: MetricWidgetThemeData(textStyle: textStyle),
        );

        await tester.pumpWidget(
          const _MetricsTextPlaceholderTestbed(text: text, theme: theme),
        );

        final textPlaceholder = tester.widget<TextPlaceholder>(
          find.byType(TextPlaceholder),
        );

        expect(textPlaceholder.style, equals(textStyle));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsTextPlaceholder] widget.
class _MetricsTextPlaceholderTestbed extends StatelessWidget {
  /// A text to display.
  final String text;

  /// The [MetricsThemeData] used in testbed.
  final MetricsThemeData theme;

  /// Creates the [_MetricsTextPlaceholderTestbed] with the given [text]
  /// and the [theme].
  ///
  /// The [theme] defaults to [MetricsThemeData].
  const _MetricsTextPlaceholderTestbed({
    Key key,
    this.text,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: MetricsTextPlaceholder(text: text),
    );
  }
}
