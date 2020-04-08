import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics_core/metrics_core.dart';

/// Stub implementation of the [ProjectMetricsStore].
///
/// Provides test implementation of the [ProjectMetricsStore] methods.
class ProjectMetricsStoreStub implements ProjectMetricsStore {
  static const testProjectMetrics = ProjectMetricsData(
    projectId: '1',
    projectName: 'project',
    coverage: Percent(0.1),
    stability: Percent(0.2),
    buildNumberMetric: 0,
    averageBuildDurationInMinutes: 1,
    performanceMetrics: [],
    buildResultMetrics: [],
  );

  final List<ProjectMetricsData> projectMetrics;

  const ProjectMetricsStoreStub({
    this.projectMetrics = const [testProjectMetrics],
  });

  @override
  Stream<List<ProjectMetricsData>> get projectsMetrics =>
      Stream.value(projectMetrics);

  @override
  Future<void> subscribeToProjects() async {}

  @override
  void dispose() {}
}
