import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:metrics_core/metrics_core.dart';

void main() {
  testWidgets(
    "Can't create the ProjectTile with null projectMetrics",
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProjectMetricsTileTestbed(
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

      await tester.pumpWidget(const ProjectMetricsTileTestbed(
        projectMetrics: metrics,
      ));

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    "Displays the ProjectMetrics even when the project name is null",
    (WidgetTester tester) async {
      const metrics = ProjectMetricsData();

      await tester.pumpWidget(const ProjectMetricsTileTestbed(
        projectMetrics: metrics,
      ));

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    "Contains coverage circle percentage",
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProjectMetricsTileTestbed());

      expect(
        find.widgetWithText(CirclePercentage, DashboardStrings.coverage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Contains stability circle percentage",
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProjectMetricsTileTestbed());

      expect(
        find.widgetWithText(CirclePercentage, DashboardStrings.stability),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Contains SparklineGraph widgets with build metric',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProjectMetricsTileTestbed());

      expect(
        find.widgetWithText(SparklineGraph, DashboardStrings.builds),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'Contains SparklineGraph widgets with performance metric',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProjectMetricsTileTestbed());

      expect(
        find.widgetWithText(SparklineGraph, DashboardStrings.performance),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Contains the bar graph with the build results",
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProjectMetricsTileTestbed());

      expect(find.byType(BuildResultBarGraph), findsOneWidget);
    },
  );
}

class ProjectMetricsTileTestbed extends StatelessWidget {
  static const ProjectMetricsData testProjectMetrics = ProjectMetricsData(
    projectName: 'Test project name',
    coverage: Percent(0.0),
    stability: Percent(0.0),
    numberOfBuilds: 0,
    averageBuildDurationInMinutes: 0,
    performanceMetrics: [],
    buildNumberMetrics: [],
    buildResultMetrics: [],
  );
  final ProjectMetricsData projectMetrics;

  const ProjectMetricsTileTestbed({
    Key key,
    this.projectMetrics = testProjectMetrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProjectMetricsTile(
          projectMetrics: projectMetrics,
        ),
      ),
    );
  }
}
