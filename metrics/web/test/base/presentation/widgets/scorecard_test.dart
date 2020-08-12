import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/scorecard.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("Scorecard", () {
    testWidgets(
      'displays an empty text if the given value is null',
      (tester) async {
        await tester.pumpWidget(const _ScorecardTestbed(value: null));

        expect(find.text(''), findsOneWidget);
      },
    );

    testWidgets(
      'displays an empty text if the given description is null',
      (tester) async {
        await tester.pumpWidget(const _ScorecardTestbed(value: null));

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
      "applies the value text style",
      (WidgetTester tester) async {
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(const _ScorecardTestbed(
          valueStyle: valueStyle,
        ));

        final valueWidget = tester.widget<Text>(
          find.text(_ScorecardTestbed.defaultValueText),
        );

        expect(valueWidget.style.color, valueStyle.color);
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

        expect(titleWidget.style.color, titleStyle.color);
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

        expect(valuePaddingWidget.padding, valuePadding);
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

  /// The text that describes the [value].
  final String description;

  /// The text to display.
  final String value;

  /// The [TextStyle] of the [description] text.
  final TextStyle descriptionStyle;

  /// The [TextStyle] of the [value] text.
  final TextStyle valueStyle;

  /// The padding of the [value] text.
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
    this.valuePadding = const EdgeInsets.all(32.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: Scorecard(
        description: description,
        value: value,
        descriptionStyle: descriptionStyle,
        valueStyle: valueStyle,
        valuePadding: valuePadding,
      ),
    );
  }
}
