import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics_core/metrics_core.dart';

class MetricsStoreStub implements ProjectMetricsStore {
  static const _testProjectMetrics = ProjectMetricsData(
    projectId: '1',
    projectName: 'project',
    coverage: Percent(0.4),
    stability: Percent(0.7),
    buildNumberMetric: 1,
    averageBuildDurationInMinutes: 1,
    performanceMetrics: [],
    buildResultMetrics: [],
  );

  final List<ProjectMetricsData> projectMetrics;

  const MetricsStoreStub({
    this.projectMetrics = const [_testProjectMetrics],
  });

  @override
  Stream<List<ProjectMetricsData>> get projectsMetrics =>
      Stream.value(projectMetrics);

  @override
  Future<void> subscribeToProjects() async {}

  @override
  void dispose() {}
}