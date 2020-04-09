import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/placeholder_text.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("PlaceholderText", () {
    testWidgets(
      "shows the DashboardString.noDataPlaceholder if no text passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderTextTestbed());

        expect(find.text(DashboardStrings.noDataPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given text",
      (WidgetTester tester) async {
        const placeholderText = 'placeholder';
        await tester.pumpWidget(const _PlaceholderTextTestbed(
          text: placeholderText,
        ));

        expect(find.text(placeholderText), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given style",
      (WidgetTester tester) async {
        const style = TextStyle(color: Colors.red);
        await tester.pumpWidget(const _PlaceholderTextTestbed(
          style: style,
        ));

        final textWidget = tester.widget<Text>(find.byType(Text));

        expect(textWidget.style, equals(style));
      },
    );

    testWidgets(
      "applies text style from inactive metrics theme",
      (WidgetTester tester) async {
        const inactiveTextStyle = TextStyle(color: Colors.grey);
        const text = 'text';
        const theme = MetricsThemeData(
          inactiveWidgetTheme: MetricWidgetThemeData(
            textStyle: inactiveTextStyle,
          ),
        );

        await tester.pumpWidget(const _PlaceholderTextTestbed(
          text: text,
          theme: theme,
        ));

        final textWidget = tester.widget<Text>(find.text(text));

        expect(textWidget.style, equals(inactiveTextStyle));
      },
    );
  });
}

class _PlaceholderTextTestbed extends StatelessWidget {
  final String text;
  final TextStyle style;
  final MetricsThemeData theme;

  const _PlaceholderTextTestbed({
    Key key,
    this.text,
    this.style,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      metricsThemeData: theme,
      body: PlaceholderText(
        text: text,
        style: style,
      ),
    );
  }
}
