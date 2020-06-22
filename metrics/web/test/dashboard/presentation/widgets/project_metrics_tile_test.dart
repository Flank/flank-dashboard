import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/models/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/text_metric.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectMetricsTile", () {
    const ProjectMetricsData testProjectMetrics = ProjectMetricsData(
      projectName: 'Test project name',
      coverage: CoverageViewModel(value: 0.3),
      stability: StabilityViewModel(value: 0.4),
      buildNumberMetric: 1,
      performanceSparkline: PerformanceSparklineViewModel(),
      buildResultMetrics: BuildResultMetricViewModel(),
    );

    testWidgets(
      "throws an AssertionError if a projectMetrics parameter is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the project name even if it is very long",
      (WidgetTester tester) async {
        const ProjectMetricsData metrics = ProjectMetricsData(
          projectName:
              'Some very long name to display that may overflow on some screens but should be displayed properly. Also, this project name has a description that placed to the project name, but we still can display it properly with any overflows.',
        );

        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: metrics,
        ));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "displays the ProjectMetricsData even when the project name is null",
      (WidgetTester tester) async {
        const metrics = ProjectMetricsData();

        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: metrics,
        ));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "contains coverage circle percentage",
      (WidgetTester tester) async {
        final coveragePercent = testProjectMetrics.coverage;
        final coverageText = '${(coveragePercent.value * 100).toInt()}%';

        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: testProjectMetrics,
        ));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(CirclePercentage, coverageText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains stability circle percentage",
      (WidgetTester tester) async {
        final stabilityPercent = testProjectMetrics.coverage;
        final stabilityText = '${(stabilityPercent.value * 100).toInt()}%';

        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: testProjectMetrics,
        ));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(CirclePercentage, stabilityText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains TextMetric with build number metric",
      (WidgetTester tester) async {
        final buildNumber = testProjectMetrics.buildNumberMetric;

        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: testProjectMetrics,
        ));

        expect(
          find.widgetWithText(TextMetric, '$buildNumber'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains SparklineGraph widgets with performance metric",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: testProjectMetrics,
        ));

        expect(
          find.byType(PerformanceSparklineGraph),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains the bar graph with the build results",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: testProjectMetrics,
        ));

        expect(find.byType(BuildResultBarGraph), findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [ProjectMetricsTile] widget.
class _ProjectMetricsTileTestbed extends StatelessWidget {
  /// The [ProjectMetricsData] instance to display.
  final ProjectMetricsData projectMetrics;

  /// Creates an instance of this testbed with the given [projectMetrics].
  const _ProjectMetricsTileTestbed({
    Key key,
    this.projectMetrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ProjectMetricsTile(
        projectMetrics: projectMetrics,
      ),
    );
  }
}
