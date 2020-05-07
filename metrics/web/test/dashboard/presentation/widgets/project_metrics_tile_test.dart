import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/text_metric.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  testWidgets(
    "Can't create the ProjectTile with null projectMetrics",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _ProjectMetricsTileTestbed(
        projectMetrics: null,
      ));

      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets(
    "Displays the project name even if it is very long",
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
    "Displays the ProjectMetrics even when the project name is null",
    (WidgetTester tester) async {
      const metrics = ProjectMetricsData();

      await tester.pumpWidget(const _ProjectMetricsTileTestbed(
        projectMetrics: metrics,
      ));

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    "Contains coverage circle percentage",
    (WidgetTester tester) async {
      final coveragePercent =
          _ProjectMetricsTileTestbed.testProjectMetrics.coverage;
      final coverageText = '${(coveragePercent.value * 100).toInt()}%';

      await tester.pumpWidget(const _ProjectMetricsTileTestbed());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(CirclePercentage, coverageText),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Contains stability circle percentage",
    (WidgetTester tester) async {
      final stabilityPercent =
          _ProjectMetricsTileTestbed.testProjectMetrics.coverage;
      final stabilityText = '${(stabilityPercent.value * 100).toInt()}%';

      await tester.pumpWidget(const _ProjectMetricsTileTestbed());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(CirclePercentage, stabilityText),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Contains TextMetric with build number metric",
    (WidgetTester tester) async {
      final buildNumber =
          _ProjectMetricsTileTestbed.testProjectMetrics.buildNumberMetric;

      await tester.pumpWidget(const _ProjectMetricsTileTestbed());

      expect(
        find.widgetWithText(TextMetric, '$buildNumber'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Contains SparklineGraph widgets with performance metric",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _ProjectMetricsTileTestbed());

      expect(
        find.byType(SparklineGraph),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Contains the bar graph with the build results",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _ProjectMetricsTileTestbed());

      expect(find.byType(BuildResultBarGraph), findsOneWidget);
    },
  );
}

class _ProjectMetricsTileTestbed extends StatelessWidget {
  static const ProjectMetricsData testProjectMetrics = ProjectMetricsData(
    projectName: 'Test project name',
    coverage: Percent(0.3),
    stability: Percent(0.4),
    buildNumberMetric: 1,
    averageBuildDurationInMinutes: 0,
    performanceMetrics: [],
    buildResultMetrics: [],
  );
  final ProjectMetricsData projectMetrics;

  const _ProjectMetricsTileTestbed({
    Key key,
    this.projectMetrics = testProjectMetrics,
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
