import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/text_metric.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("TextMetric", () {
    testWidgets(
      "can't be created with null description",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextMetricTestbed(
          description: null,
          value: 'value',
        ));

        expect(
          tester.takeException(),
          isAssertionError,
        );
      },
    );

    testWidgets(
      "can't be created with null value",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextMetricTestbed(
          value: null,
          description: 'description',
        ));

        expect(
          tester.takeException(),
          isAssertionError,
        );
      },
    );

    testWidgets(
      "displays the description text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextMetricTestbed());

        expect(find.text(_TextMetricTestbed.defaultDescriptionText),
            findsOneWidget);
      },
    );

    testWidgets(
      "displays the value text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TextMetricTestbed());

        expect(find.text(_TextMetricTestbed.defaultValueText), findsOneWidget);
      },
    );

    testWidgets(
      "applies the value text style",
      (WidgetTester tester) async {
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(const _TextMetricTestbed(
          valueStyle: valueStyle,
        ));

        final valueWidget = tester.widget<Text>(
          find.text(_TextMetricTestbed.defaultValueText),
        );

        expect(valueWidget.style.color, valueStyle.color);
      },
    );

    testWidgets(
      "applies the description text style",
      (WidgetTester tester) async {
        const titleStyle = TextStyle(color: Colors.blue);

        await tester.pumpWidget(const _TextMetricTestbed(
          descriptionStyle: titleStyle,
        ));

        final titleWidget = tester.widget<Text>(
          find.text(_TextMetricTestbed.defaultDescriptionText),
        );

        expect(titleWidget.style.color, titleStyle.color);
      },
    );

    testWidgets(
      "applies padding to value text",
      (WidgetTester tester) async {
        const valuePadding = EdgeInsets.all(8.0);

        await tester.pumpWidget(const _TextMetricTestbed(
          valuePadding: valuePadding,
        ));

        final valuePaddingWidget = tester.widget<Padding>(
          find.widgetWithText(Padding, _TextMetricTestbed.defaultValueText),
        );

        expect(valuePaddingWidget.padding, valuePadding);
      },
    );
  });
}

class _TextMetricTestbed extends StatelessWidget {
  static const defaultDescriptionText = 'description';
  static const defaultValueText = 'value';

  final String description;
  final String value;
  final TextStyle descriptionStyle;
  final TextStyle valueStyle;
  final EdgeInsets valuePadding;

  const _TextMetricTestbed({
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
      body: TextMetric(
        description: description,
        value: value,
        descriptionStyle: descriptionStyle,
        valueStyle: valueStyle,
        valuePadding: valuePadding,
      ),
    );
  }
}
