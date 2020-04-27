import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ExpandableText", () {
    testWidgets(
      "displays the given text",
      (tester) async {
        const text = 'given text';
        await tester.pumpWidget(const _ExpandableTextTestbed(
          text: text,
        ));

        expect(find.text(text), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given text style",
      (tester) async {
        const textStyle = TextStyle(color: Colors.red);
        await tester.pumpWidget(const _ExpandableTextTestbed(
          style: textStyle,
        ));

        final textWidget = tester.widget<Text>(find.byType(Text));

        expect(textWidget.style, textStyle);
      },
    );

    testWidgets(
      "fits large text into a small box",
      (tester) async {
        const textSize = 20.0;
        const text = 'some large text to fit the small box ...';

        await tester.pumpWidget(const _ExpandableTextTestbed(
          text: text,
          height: textSize,
          width: textSize,
        ));

        expect(find.text(text), findsOneWidget);
      },
    );

    testWidgets(
      "displays the text inside of FittedBox with BoxFit.contains fit",
      (tester) async {
        const text = 'test text';
        await tester.pumpWidget(const _ExpandableTextTestbed(
          text: text,
        ));

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is FittedBox &&
                widget.fit == BoxFit.contain &&
                widget.child is Text,
          ),
          findsOneWidget,
        );
      },
    );
  });
}

class _ExpandableTextTestbed extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double height;
  final double width;

  const _ExpandableTextTestbed({
    Key key,
    this.text = 'text',
    this.style,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ExpandableText(
                text,
                style: style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
