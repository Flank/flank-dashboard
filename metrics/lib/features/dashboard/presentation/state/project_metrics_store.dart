import 'dart:async';
import 'dart:math';

import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:rxdart/rxdart.dart';

/// The store for the project metrics.
///
/// Stores the [Project]s and their [DashboardProjectMetrics].
class ProjectMetricsStore {
  final ReceiveProjectUpdates _receiveProjectsUpdates;
  final ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;
  final Map<String, StreamSubscription> _buildMetricsSubscriptions = {};
  final BehaviorSubject<Map<String, ProjectMetricsData>>
      _projectsMetricsSubject = BehaviorSubject();

  StreamSubscription _projectsSubscription;

  /// Creates the project metrics store.
  ///
  /// The provided use cases should not be null.
  ProjectMetricsStore(
    this._receiveProjectsUpdates,
    this._receiveProjectMetricsUpdates,
  ) : assert(
          _receiveProjectsUpdates != null &&
              _receiveProjectMetricsUpdates != null,
          'The use cases should not be null',
        );

  Stream<List<ProjectMetricsData>> get projectsMetrics =>
      _projectsMetricsSubject.map((metricsMap) => metricsMap.values.toList());

  /// Subscribes to projects and its metrics.
  Future<void> subscribeToProjects() async {
    final projectsStream = _receiveProjectsUpdates();
    await _projectsSubscription?.cancel();

    _projectsSubscription = projectsStream.listen(_projectsListener);
  }

  /// Listens to project updates.
  void _projectsListener(List<Project> newProjects) {
    if (newProjects == null || newProjects.isEmpty) {
      _projectsMetricsSubject.add({});
      return;
    }

    final projectsMetrics = _projectsMetricsSubject.value ?? {};

    final projectIds = newProjects.map((project) => project.id);
    projectsMetrics.removeWhere((projectId, value) {
      final remove = !projectIds.contains(projectId);
      if (remove) {
        _buildMetricsSubscriptions.remove(projectId)?.cancel();
      }

      return remove;
    });

    for (final project in newProjects) {
      final projectId = project.id;

      ProjectMetricsData projectMetrics =
          projectsMetrics[projectId] ?? const ProjectMetricsData();

      if (projectMetrics.projectName != project.name) {
        projectMetrics = projectMetrics.copyWith(
          projectName: project.name,
        );
      }

      if (!projectsMetrics.containsKey(projectId)) {
        _subscribeToBuildMetrics(projectId);
      }
      projectsMetrics[projectId] = projectMetrics;
    }

    _projectsMetricsSubject.add(projectsMetrics);
  }

  /// Subscribes to project metrics.
  void _subscribeToBuildMetrics(String projectId) {
    final buildMetricsStream = _receiveProjectMetricsUpdates(
      ProjectIdParam(projectId),
    );

    _buildMetricsSubscriptions[projectId] =
        buildMetricsStream.listen((metrics) {
      _createBuildMetrics(metrics, projectId);
    });
  }

  /// Create project metrics form [DashboardProjectMetrics].
  void _createBuildMetrics(
      DashboardProjectMetrics buildMetrics, String projectId) {
    final projectsMetrics = _projectsMetricsSubject.value;

    final projectMetrics = projectsMetrics[projectId];

    if (projectMetrics == null || buildMetrics == null) return;

    final performanceMetrics = _getPerformanceMetrics(
      buildMetrics.performanceMetrics,
    );
    final buildResultMetrics = _getBuildResultMetrics(
      buildMetrics.buildResultMetrics,
    );
    final averageBuildDuration =
        buildMetrics.performanceMetrics.averageBuildDuration.inMinutes;
    final numberOfBuilds = buildMetrics.buildNumberMetrics.numberOfBuilds;

    projectsMetrics[projectId] = projectMetrics.copyWith(
      performanceMetrics: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      numberOfBuilds: numberOfBuilds,
      averageBuildDurationInMinutes: averageBuildDuration,
      coverage: buildMetrics.coverage,
      stability: buildMetrics.stability,
    );

    _projectsMetricsSubject.add(projectsMetrics);
  }

  /// Creates the project performance metrics from [PerformanceMetric].
  List<Point<int>> _getPerformanceMetrics(PerformanceMetric metric) {
    final performanceMetrics = metric?.buildsPerformance ?? DateTimeSet();

    if (performanceMetrics.isEmpty) {
      return [];
    }

    return performanceMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.duration.inMilliseconds,
      );
    }).toList();
  }

  /// Creates the project build result metrics from [BuildResultMetric].
  List<BuildResultBarData> _getBuildResultMetrics(BuildResultMetric metrics) {
    final buildResults = metrics?.buildResults ?? [];

    if (buildResults.isEmpty) {
      return [];
    }

    return buildResults.map((result) {
      return BuildResultBarData(
        url: result.url,
        buildStatus: result.buildStatus,
        value: result.duration.inMilliseconds,
      );
    }).toList();
  }

  /// Cancels all created subscriptions.
  void dispose() {
    _projectsSubscription?.cancel();
    for (final subscription in _buildMetricsSubscriptions.values) {
      subscription?.cancel();
    }
    _buildMetricsSubscriptions.clear();
  }
}
