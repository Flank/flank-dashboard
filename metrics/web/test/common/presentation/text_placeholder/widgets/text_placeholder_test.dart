// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/text_placeholder/theme/theme_data/text_placeholder_theme_data.dart';
import 'package:metrics/common/presentation/text_placeholder/widgets/text_placeholder.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("TextPlaceholder", () {
    testWidgets(
      "throws an AssertionError if a text is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextPlaceholderTestbed(
          text: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given text",
      (WidgetTester tester) async {
        const text = 'test';

        await tester.pumpWidget(
          const _TextPlaceholderTestbed(text: text),
        );

        expect(find.text(text), findsOneWidget);
      },
    );

    testWidgets(
      "applies the text style from the text placeholder theme",
      (WidgetTester tester) async {
        const text = 'test-text';
        const textStyle = TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );

        const theme = MetricsThemeData(
          textPlaceholderTheme: TextPlaceholderThemeData(textStyle: textStyle),
        );

        await tester.pumpWidget(
          const _TextPlaceholderTestbed(theme: theme, text: text),
        );

        final textWidget = tester.widget<Text>(
          find.text(text),
        );

        expect(textWidget.style, equals(textStyle));
      },
    );
  });
}

/// A testbed widget, used to test the [TextPlaceholder] widget.
class _TextPlaceholderTestbed extends StatelessWidget {
  /// A text to display.
  final String text;

  /// The [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates the [_TextPlaceholderTestbed] with the given [text]
  /// and [theme].
  ///
  /// The [text] defaults to `text`.
  /// The [theme] defaults to [MetricsThemeData].
  const _TextPlaceholderTestbed({
    Key key,
    this.text = 'text',
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: TextPlaceholder(text: text),
    );
  }
}
