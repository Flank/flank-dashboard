import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/build_point_adapter.dart';
import 'package:metrics/features/dashboard/presentation/model/adapter/performance_point_adapter.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
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
  });
}

class DashboardTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<ProjectMetricsStore>(() => CoverageStoreStub()),
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

class CoverageStoreStub implements ProjectMetricsStore {
  @override
  Coverage get coverage => const Coverage(percent: 0.3);

  @override
  Future<void> getCoverage(String projectId) async {}

  @override
  int get averageBuildTime => throw UnimplementedError();

  @override
  Future getBuildMetrics(String projectId) {
    return Future.value(null);
  }

  @override
  List<BuildPointAdapter> get projectBuildMetric => [];

  @override
  List<PerformancePointAdapter> get projectPerformanceMetric => [];

  @override
  int get totalBuildNumber => null;
}
