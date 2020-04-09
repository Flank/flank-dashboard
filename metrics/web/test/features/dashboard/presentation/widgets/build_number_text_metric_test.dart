import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_number_text_metric.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  group("BuildNumberTextMetric", () {
    testWidgets(
      "displays the given build number metric",
      (WidgetTester tester) async {
        const buildNumber = 10;
        await tester.pumpWidget(const _BuildNumberTextMetricTestbed(
          buildNumberMetric: buildNumber,
        ));

        expect(find.text("$buildNumber"), findsOneWidget);
      },
    );

    testWidgets(
      "applies the text style for the metric widget theme",
      (WidgetTester tester) async {
        const textStyle = TextStyle(color: Colors.red);
        const buildNumber = 3;
        const theme = MetricsThemeData(
          metricWidgetTheme: MetricWidgetThemeData(
            textStyle: textStyle,
          ),
        );

        await tester.pumpWidget(const _BuildNumberTextMetricTestbed(
          buildNumberMetric: buildNumber,
          metricsThemeData: theme,
        ));

        final buildNumberMetricText =
            tester.widget<Text>(find.text('$buildNumber'));

        expect(buildNumberMetricText.style, equals(textStyle));
      },
    );
  });
}

class _BuildNumberTextMetricTestbed extends StatelessWidget {
  final int buildNumberMetric;
  final MetricsThemeData metricsThemeData;

  const _BuildNumberTextMetricTestbed({
    Key key,
    this.buildNumberMetric = 1,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      metricsThemeData: metricsThemeData,
      body: BuildNumberTextMetric(
        buildNumberMetric: buildNumberMetric,
      ),
    );
  }
}
