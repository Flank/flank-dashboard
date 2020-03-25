import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/titled_text.dart';

void main() {
  group("TitledText", () {
    testWidgets(
      "can't be created with null title",
      (WidgetTester tester) async {
        await tester.pumpWidget(const TitledTextTestbed(
          title: null,
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
        await tester.pumpWidget(const TitledTextTestbed(
          value: null,
        ));

        expect(
          tester.takeException(),
          isAssertionError,
        );
      },
    );

    testWidgets(
      'displays the title and value texts',
      (WidgetTester tester) async {
        await tester.pumpWidget(const TitledTextTestbed());

        expect(find.text(TitledTextTestbed.defaultTitleText), findsOneWidget);
        expect(find.text(TitledTextTestbed.defaultValueText), findsOneWidget);
      },
    );

    testWidgets(
      "applies value and title text styles",
      (WidgetTester tester) async {
        const titleStyle = TextStyle(color: Colors.blue);
        const valueStyle = TextStyle(color: Colors.red);

        await tester.pumpWidget(const TitledTextTestbed(
          titleStyle: titleStyle,
          valueStyle: valueStyle,
        ));

        final titleWidget = tester.widget<Text>(
          find.text(TitledTextTestbed.defaultTitleText),
        );
        final valueWidget = tester.widget<Text>(
          find.text(TitledTextTestbed.defaultValueText),
        );

        expect(titleWidget.style.color, titleStyle.color);
        expect(valueWidget.style.color, valueStyle.color);
      },
    );

    testWidgets(
      'applies padding to value text',
      (WidgetTester tester) async {
        const valuePadding = EdgeInsets.all(8.0);

        await tester.pumpWidget(const TitledTextTestbed(
          valuePadding: valuePadding,
        ));

        final valuePaddingWidget = tester.widget<Padding>(
          find.widgetWithText(Padding, TitledTextTestbed.defaultValueText),
        );

        expect(valuePaddingWidget.padding, valuePadding);
      },
    );
  });
}

class TitledTextTestbed extends StatelessWidget {
  static const defaultTitleText = 'title';
  static const defaultValueText = 'value';

  final String title;
  final String value;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final EdgeInsets valuePadding;

  const TitledTextTestbed({
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
        body: TitledText(
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
