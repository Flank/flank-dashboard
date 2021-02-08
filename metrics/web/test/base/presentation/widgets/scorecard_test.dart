// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/scorecard.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("Scorecard", () {
    testWidgets(
      "displays an empty text if the given value is null",
      (tester) async {
        await tester.pumpWidget(const _ScorecardTestbed(value: null));

        expect(find.text(''), findsOneWidget);
      },
    );

    testWidgets(
      "displays an empty text if the given description is null",
      (tester) async {
        await tester.pumpWidget(const _ScorecardTestbed(description: null));

        expect(find.text(''), findsOneWidget);
      },
    );

    testWidgets(
      "displays the description text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ScorecardTestbed());

        expect(
          find.text(_ScorecardTestbed.defaultDescriptionText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the value text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ScorecardTestbed());

        expect(find.text(_ScorecardTestbed.defaultValueText), findsOneWidget);
      },
    );

    testWidgets(
      "uses the auto size text widget to display the value",
      (WidgetTester tester) async {
        const value = 'test';

        await tester.pumpWidget(const _ScorecardTestbed(
          value: value,
        ));

        expect(
          find.widgetWithText(AutoSizeText, value),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "reduces the value font size to fit the constraints",
      (WidgetTester tester) async {
        const value = 'very long name 12345678910';
        const initialFontSize = 100.0;
        const valueStyle = TextStyle(fontSize: initialFontSize);

        await tester.pumpWidget(const _ScorecardTestbed(
          value: value,
          valueStyle: valueStyle,
          constraints: BoxConstraints(maxWidth: 50),
        ));

        final valueFinder = find.text(value);
        final valueWidget = tester.widget<Text>(valueFinder);
        final actualFontSize = valueWidget.style.fontSize;

        expect(actualFontSize, lessThan(initialFontSize));
      },
    );

    testWidgets(
      "applies the value text style",
      (WidgetTester tester) async {
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(const _ScorecardTestbed(
          valueStyle: valueStyle,
        ));

        final valueWidget = tester.widget<AutoSizeText>(
          find.widgetWithText(AutoSizeText, _ScorecardTestbed.defaultValueText),
        );

        expect(valueWidget.style, equals(valueStyle));
      },
    );

    testWidgets(
      "applies the description text style",
      (WidgetTester tester) async {
        const titleStyle = TextStyle(color: Colors.blue);

        await tester.pumpWidget(const _ScorecardTestbed(
          descriptionStyle: titleStyle,
        ));

        final titleWidget = tester.widget<Text>(
          find.text(_ScorecardTestbed.defaultDescriptionText),
        );

        expect(titleWidget.style, equals(titleStyle));
      },
    );

    testWidgets(
      "applies padding to value text",
      (WidgetTester tester) async {
        const valuePadding = EdgeInsets.all(8.0);

        await tester.pumpWidget(const _ScorecardTestbed(
          valuePadding: valuePadding,
        ));

        final valuePaddingWidget = tester.widget<Padding>(
          find.widgetWithText(Padding, _ScorecardTestbed.defaultValueText),
        );

        expect(valuePaddingWidget.padding, equals(valuePadding));
      },
    );
  });
}

/// A testbed class needed to test the [Scorecard] widget.
class _ScorecardTestbed extends StatelessWidget {
  /// A default description text used in tests.
  static const defaultDescriptionText = 'description';

  /// A default value text used in tests.
  static const defaultValueText = 'value';

  /// A text that describes the [value].
  final String description;

  /// A text to display.
  final String value;

  /// A [TextStyle] of the [description] text.
  final TextStyle descriptionStyle;

  /// A [BoxConstraints] to use under tests to imitate this widget's
  /// layout constraints.
  final BoxConstraints constraints;

  /// A [TextStyle] of the [value] text.
  final TextStyle valueStyle;

  /// A padding of the [value] text.
  final EdgeInsets valuePadding;

  /// Creates a new instance of this testbed.
  ///
  /// If the [description] is not provided, the [defaultDescriptionText] used.
  /// If the [value] is not provided, the [defaultValueText] used.
  /// If the [valuePadding] is not provided,
  /// the [EdgeInsets.all] with value equals to `32.0` used.
  const _ScorecardTestbed({
    Key key,
    this.description = defaultDescriptionText,
    this.value = defaultValueText,
    this.descriptionStyle,
    this.valueStyle,
    this.constraints,
    this.valuePadding = const EdgeInsets.all(32.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: Container(
        constraints: constraints,
        child: Scorecard(
          description: description,
          value: value,
          descriptionStyle: descriptionStyle,
          valueStyle: valueStyle,
          valuePadding: valuePadding,
        ),
      ),
    );
  }
}
