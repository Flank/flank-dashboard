import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/text_metric.dart';

void main() {
  group("TextMetric", () {
    testWidgets(
      "can't be created with null title",
      (WidgetTester tester) async {
        await tester.pumpWidget(const TextMetricTestbed(
          title: null,
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
        await tester.pumpWidget(const TextMetricTestbed(
          value: null,
          title: 'title',
        ));

        expect(
          tester.takeException(),
          isAssertionError,
        );
      },
    );

    testWidgets(
      "displays the title text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const TextMetricTestbed());

        expect(find.text(TextMetricTestbed.defaultTitleText), findsOneWidget);
      },
    );

    testWidgets(
      "displays the value text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const TextMetricTestbed());

        expect(find.text(TextMetricTestbed.defaultValueText), findsOneWidget);
      },
    );

    testWidgets(
      "applies value and title text styles",
      (WidgetTester tester) async {
        const titleStyle = TextStyle(color: Colors.blue);
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(const TextMetricTestbed(
          titleStyle: titleStyle,
          valueStyle: valueStyle,
        ));

        final titleWidget = tester.widget<Text>(
          find.text(TextMetricTestbed.defaultTitleText),
        );
        final valueWidget = tester.widget<Text>(
          find.text(TextMetricTestbed.defaultValueText),
        );

        expect(titleWidget.style.color, titleStyle.color);
        expect(valueWidget.style.color, valueStyle.color);
      },
    );

    testWidgets(
      "applies padding to value text",
      (WidgetTester tester) async {
        const valuePadding = EdgeInsets.all(8.0);

        await tester.pumpWidget(const TextMetricTestbed(
          valuePadding: valuePadding,
        ));

        final valuePaddingWidget = tester.widget<Padding>(
          find.widgetWithText(Padding, TextMetricTestbed.defaultValueText),
        );

        expect(valuePaddingWidget.padding, valuePadding);
      },
    );
  });
}

class TextMetricTestbed extends StatelessWidget {
  static const defaultTitleText = 'title';
  static const defaultValueText = 'value';

  final String title;
  final String value;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final EdgeInsets valuePadding;

  const TextMetricTestbed({
    Key key,
    this.title = defaultTitleText,
    this.value = defaultValueText,
    this.titleStyle,
    this.valueStyle,
    this.valuePadding = const EdgeInsets.all(32.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextMetric(
          title: title,
          value: value,
          titleStyle: titleStyle,
          valueStyle: valueStyle,
          valuePadding: valuePadding,
        ),
      ),
    );
  }
}
