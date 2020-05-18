import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_updates.dart';
import 'package:metrics/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/dashboard/presentation/model/filter.dart';
import 'package:metrics/dashboard/presentation/model/filters.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds the projects metrics state.
///
/// Stores the [Project]s and their [DashboardProjectMetrics].
class ProjectMetricsNotifier extends ChangeNotifier {
  /// Provides an ability to receive project updates.
  final ReceiveProjectUpdates _receiveProjectsUpdates;

  /// Provides an ability to receive project metrics updates.
  final ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;

  /// A [Map] that holds all created [StreamSubscription].
  final Map<String, StreamSubscription> _buildMetricsSubscriptions = {};

  /// A [Map] that holds all loaded [ProjectMetricsData].
  Map<String, ProjectMetricsData> _projectMetrics;

  /// The stream subscription needed to be able to stop listening
  /// to the project updates.
  StreamSubscription _projectsSubscription;

  /// Holds the error message that occurred during loading data.
  String _errorMessage;

  /// Creates the project metrics store.
  ///
  /// The provided use cases should not be null.
  ProjectMetricsNotifier(
      this._receiveProjectsUpdates,
      this._receiveProjectMetricsUpdates,
      ) : assert(
  _receiveProjectsUpdates != null &&
      _receiveProjectMetricsUpdates != null,
  'The use cases should not be null',
  );

  /// Provides a list of project metrics.
  List<ProjectMetricsData> get projectsMetrics =>
      _projectsMetricsFilters.applyAll(_projectMetrics?.values?.toList());

  final _projectsMetricsFilters = Filters<ProjectMetricsData>();

  void addFilter(Filter<ProjectMetricsData> filter) {
    _projectsMetricsFilters.addFilter(filter);
    notifyListeners();
  }

  /// Provides an error description that occurred during loading metrics data.
  String get errorMessage => _errorMessage;

  /// Subscribes to projects and its metrics.
  Future<void> subscribeToProjects() async {
    final projectsStream = _receiveProjectsUpdates();
    _errorMessage = null;
    await _projectsSubscription?.cancel();

    _projectsSubscription = projectsStream.listen(
      _projectsListener,
      onError: _errorHandler,
    );
  }

  /// Unsubscribes from projects and it's metrics.
  Future<void> unsubscribeFromProjects() async {
    await _cancelSubscriptions();
    notifyListeners();
  }

  /// Listens to project updates.
  void _projectsListener(List<Project> newProjects) {
    if (newProjects == null) return;

    if (newProjects.isEmpty) {
      _projectMetrics = {};
      notifyListeners();
      return;
    }

    final projectsMetrics = _projectMetrics ?? {};

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

    _projectMetrics = projectsMetrics;
    notifyListeners();
  }

  /// Subscribes to project metrics.
  void _subscribeToBuildMetrics(String projectId) {
    final dashboardMetricsStream = _receiveProjectMetricsUpdates(
      ProjectIdParam(projectId),
    );

    _buildMetricsSubscriptions[projectId] =
        dashboardMetricsStream.listen((metrics) {
          _createProjectMetrics(metrics, projectId);
        }, onError: _errorHandler);
  }

  /// Creates project metrics from [DashboardProjectMetrics].
  void _createProjectMetrics(
      DashboardProjectMetrics dashboardMetrics, String projectId) {
    final projectsMetrics = _projectMetrics ?? {};

    final projectMetrics = projectsMetrics[projectId];

    if (projectMetrics == null || dashboardMetrics == null) return;

    final performanceMetrics = _getPerformanceMetrics(
      dashboardMetrics.performanceMetrics,
    );
    final buildResultMetrics = _getBuildResultMetrics(
      dashboardMetrics.buildResultMetrics,
    );
    final averageBuildDuration =
        dashboardMetrics.performanceMetrics.averageBuildDuration.inMinutes;
    final numberOfBuilds = dashboardMetrics.buildNumberMetrics.numberOfBuilds;

    projectsMetrics[projectId] = projectMetrics.copyWith(
      performanceMetrics: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      buildNumberMetric: numberOfBuilds,
      averageBuildDurationInMinutes: averageBuildDuration,
      coverage: dashboardMetrics.coverage,
      stability: dashboardMetrics.stability,
    );

    _projectMetrics = projectsMetrics;
    notifyListeners();
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
  Future<void> _cancelSubscriptions() async {
    await _projectsSubscription?.cancel();
    for (final subscription in _buildMetricsSubscriptions.values) {
      await subscription?.cancel();
    }
    _projectMetrics = null;
    _buildMetricsSubscriptions.clear();
  }

  /// Saves the error [String] representation to [_errorMessage].
  void _errorHandler(error) {
    if (error is PlatformException) {
      _errorMessage = error.message;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }
}
