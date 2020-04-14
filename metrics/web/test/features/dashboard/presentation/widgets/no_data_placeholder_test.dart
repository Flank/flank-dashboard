import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/no_data_placeholder.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("NoDataPlaceholder", () {
    testWidgets(
      "shows the DashboardStrings.noDataPlaceholder",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _PlaceholderTextTestbed());

        expect(find.text(DashboardStrings.noDataPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "applies text style from inactive metrics theme",
      (WidgetTester tester) async {
        const inactiveTextStyle = TextStyle(color: Colors.grey);
        const theme = MetricsThemeData(
          inactiveWidgetTheme: MetricWidgetThemeData(
            textStyle: inactiveTextStyle,
          ),
        );

        await tester.pumpWidget(const _PlaceholderTextTestbed(
          theme: theme,
        ));

        final textWidget = tester.widget<Text>(
          find.text(DashboardStrings.noDataPlaceholder),
        );

        expect(textWidget.style, equals(inactiveTextStyle));
      },
    );
  });
}

class _PlaceholderTextTestbed extends StatelessWidget {
  final MetricsThemeData theme;

  const _PlaceholderTextTestbed({
    Key key,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      metricsThemeData: theme,
      body: const NoDataPlaceholder(),
    );
  }
}
