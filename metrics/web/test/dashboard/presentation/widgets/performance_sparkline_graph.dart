import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/sparkline_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("PerformanceSparklineGraph", () {
    const performanceMetricValue = 1;
    const performanceMetric = PerformanceMetricViewModel(
      performance: [Point(1, 2)],
      value: performanceMetricValue,
    );

    const metricsTheme = MetricsThemeData(
        metricWidgetTheme: MetricWidgetThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.grey,
    ));

    testWidgets(
      "can't be created with null performance metric",
      (tester) async {
        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceMetric: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets("displays the value text", (tester) async {
      await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
        performanceMetric: performanceMetric,
      ));

      expect(
        find.text(DashboardStrings.minutes(performanceMetricValue)),
        findsOneWidget,
      );
    });

    testWidgets(
      "delegates the performance to the SparklineGraph",
      (tester) async {
        const performance = [Point(1, 2)];
        const performanceMetric =
            PerformanceMetricViewModel(performance: performance);

        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceMetric: performanceMetric,
        ));

        final sparklineGraph = tester.widget<SparklineGraph>(
          find.byType(SparklineGraph),
        );

        expect(sparklineGraph.data, equals(performance));
      },
    );

    testWidgets(
      "displays the no data placeholder if the given performance metric is empty",
      (tester) async {
        const performanceMetric = PerformanceMetricViewModel();

        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceMetric: performanceMetric,
        ));

        expect(
          find.byType(NoDataPlaceholder),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "applies the metricsWidgetTheme primary color to value text",
      (tester) async {
        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceMetric: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final valueText = tester.widget<Text>(
            find.text(DashboardStrings.minutes(performanceMetricValue)));

        expect(
          valueText.style.color,
          equals(metricsTheme.metricWidgetTheme.primaryColor),
        );
      },
    );

    testWidgets(
      "applies the metricsWidgetTheme primary color to the sparkline graph's stroke color",
      (tester) async {
        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceMetric: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final sparklineGraph = tester.widget<SparklineGraph>(
          find.byType(SparklineGraph),
        );

        expect(
          sparklineGraph.strokeColor,
          equals(metricsTheme.metricWidgetTheme.primaryColor),
        );
      },
    );

    testWidgets(
      "applies the metricsWidgetTheme accent color to the sparkline graph's fill color",
      (tester) async {
        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceMetric: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final sparklineGraph = tester.widget<SparklineGraph>(
          find.byType(SparklineGraph),
        );

        expect(
          sparklineGraph.fillColor,
          equals(metricsTheme.metricWidgetTheme.accentColor),
        );
      },
    );
  });
}

/// A testbed class needed to test the [PerformanceSparklineGraph] widget.
class _PerformanceSparklineGraphTestbed extends StatelessWidget {
  /// A [PerformanceMetricViewModel] test data used as a default value in this testbed.
  static const _performanceMetricTestData = PerformanceMetricViewModel(
    performance: [Point(1, 2)],
  );

  /// A [PerformanceMetricViewModel] to display.
  final PerformanceMetricViewModel performanceMetric;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsTheme;

  /// Creates a [_PerformanceSparklineGraphTestbed] with the given [performanceMetric].
  const _PerformanceSparklineGraphTestbed({
    Key key,
    this.performanceMetric = _performanceMetricTestData,
    this.metricsTheme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsTheme,
      body: PerformanceSparklineGraph(
        performanceMetric: performanceMetric,
      ),
    );
  }
}
