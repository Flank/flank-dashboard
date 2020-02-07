import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  group("Dashboard configuration", () {
    testWidgets(
      "Contains Circle percentage with coverage",
      (WidgetTester tester) async {
        await tester.pumpWidget(DashboardTestbed());
        await tester.pumpAndSettle();
        expect(find.byType(CirclePercentage), findsOneWidget);
      },
    );

    testWidgets(
      'Contains SparklineGraph widgets with performance and build metrics',
      (WidgetTester tester) async {
        await tester.pumpWidget(DashboardTestbed());
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byType(SparklineGraph),
            matching: find.text('Performance'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(SparklineGraph),
            matching: find.text('Build'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}

class DashboardTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<ProjectMetricsStore>(() => MetricsStoreStub()),
        ],
        initState: () {
          Injector.getAsReactive<ProjectMetricsStore>()
              .setState((store) => store.getCoverage('projectId'));
        },
        builder: (BuildContext context) => DashboardPage(),
      ),
    );
  }
}

class MetricsStoreStub implements ProjectMetricsStore {
  @override
  Coverage get coverage => const Coverage(percent: 0.3);

  @override
  Future<void> getCoverage(String projectId) async {}

  @override
  int get averageBuildTime => 20;

  @override
  Future getBuildMetrics(String projectId) async {}

  @override
  int get totalBuildNumber => null;

  @override
  List<Point<int>> get projectBuildNumberMetrics => [];

  @override
  List<BuildResultBarData> get projectBuildResultMetrics => [];

  @override
  List<Point<int>> get projectPerformanceMetrics => [];
}
