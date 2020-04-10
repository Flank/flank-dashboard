import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("ExapndableText", () {
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
  });
}

class _ExpandableTextTestbed extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _ExpandableTextTestbed({
    Key key,
    this.text = 'text',
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ExpandableText(
              text,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
