import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/models/project_metrics_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:rxdart/rxdart.dart';

/// The [ChangeNotifier] that holds the projects metrics data.
class ProjectMetricsNotifier extends ChangeNotifier {
  /// Provides an ability to receive project metrics updates.
  final ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;

  /// A [Map] that holds all created [StreamSubscription].
  final Map<String, StreamSubscription> _buildMetricsSubscriptions = {};

  /// A [PublishSubject] that provides an ability to filter projects by the name.
  final _projectNameFilterSubject = PublishSubject<String>();

  /// A [Map] that holds all loaded [ProjectMetricsData].
  Map<String, ProjectMetricsData> _projectMetrics;

  /// Holds the error message that occurred during loading projects data.
  String _projectsErrorMessage;

  /// An optional filter value that represents a part (or full) project name
  /// used to limit the displayed data.
  String _projectNameFilter;

  /// Provides a list of project metrics, filtered by the project name filter.
  List<ProjectMetricsData> get projectsMetrics {
    final List<ProjectMetricsData> projectMetricsData =
        _projectMetrics?.values?.toList();

    if (_projectNameFilter == null || projectMetricsData == null) {
      return projectMetricsData;
    }

    return projectMetricsData
        .where((project) => project.projectName
            .toLowerCase()
            .contains(_projectNameFilter.toLowerCase()))
        .toList();
  }

  /// Provides an error description that occurred during loading metrics data.
  String get projectsErrorMessage => _projectsErrorMessage;

  /// Creates a new instance of the [ProjectMetricsNotifier].
  ///
  /// The given [ReceiveProjectMetricsUpdates] must not be null.
  ProjectMetricsNotifier(
    this._receiveProjectMetricsUpdates,
  ) : assert(
          _receiveProjectMetricsUpdates != null,
          'The use case must not be null',
        ) {
    _subscribeToProjectsNameFilter();
  }

  /// Subscribes to a projects name filter.
  void _subscribeToProjectsNameFilter() {
    _projectNameFilterSubject
        .debounceTime(DurationConstants.debounce)
        .listen((value) {
      _projectNameFilter = value;
      notifyListeners();
    });
  }

  /// Adds project metrics filter using the given [value].
  void filterByProjectName(String value) {
    _projectNameFilterSubject.add(value);
  }

  /// Updates projects and an error message.
  void updateProjects(List<ProjectModel> newProjects, String errorMessage) {
    _projectsErrorMessage = errorMessage;

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

      ProjectMetricsData projectMetrics = projectsMetrics[projectId] ??
          ProjectMetricsData(projectId: projectId);

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

  /// Unsubscribes from project metrics.
  Future<void> unsubscribeFromBuildMetrics() async {
    await _cancelSubscriptions();
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
    }, onError: _projectsErrorHandler);
  }

  /// Creates project metrics from the [DashboardProjectMetrics].
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
    final numberOfBuilds = dashboardMetrics.buildNumberMetrics.numberOfBuilds;

    projectsMetrics[projectId] = projectMetrics.copyWith(
      performanceSparkline: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      buildNumberMetric: numberOfBuilds,
      coverage: CoverageViewModel(value: dashboardMetrics.coverage?.value),
      stability: StabilityViewModel(value: dashboardMetrics.stability?.value),
    );

    _projectMetrics = projectsMetrics;
    notifyListeners();
  }

  /// Creates the project performance metrics from [PerformanceMetric].
  PerformanceSparklineViewModel _getPerformanceMetrics(
      PerformanceMetric metric) {
    final performanceMetrics = metric?.buildsPerformance ?? DateTimeSet();

    if (performanceMetrics.isEmpty) {
      return const PerformanceSparklineViewModel();
    }

    final performance = performanceMetrics.map((metric) {
      return Point(
        metric.date.millisecondsSinceEpoch,
        metric.duration.inMilliseconds,
      );
    }).toList();

    final averageBuildDuration = metric.averageBuildDuration.inMinutes;

    return PerformanceSparklineViewModel(
      performance: performance,
      value: averageBuildDuration,
    );
  }

  /// Creates the project build result metrics from [BuildResultMetric].
  BuildResultMetricViewModel _getBuildResultMetrics(BuildResultMetric metrics) {
    final buildResults = metrics?.buildResults ?? [];

    if (buildResults.isEmpty) {
      return const BuildResultMetricViewModel();
    }

    final buildResultViewModels = buildResults.map((result) {
      return BuildResultViewModel(
        url: result.url,
        buildStatus: result.buildStatus,
        value: result.duration.inMilliseconds,
      );
    }).toList();

    return BuildResultMetricViewModel(buildResults: buildResultViewModels);
  }

  /// Cancels all created subscriptions.
  Future<void> _cancelSubscriptions() async {
    for (final subscription in _buildMetricsSubscriptions.values) {
      await subscription?.cancel();
    }
    _projectMetrics = null;
    _buildMetricsSubscriptions.clear();
  }

  /// Saves the error [String] representation to the [_projectsErrorMessage].
  void _projectsErrorHandler(error) {
    if (error is PlatformException) {
      _projectsErrorMessage = error.message;
      notifyListeners();
    }
  }

  @override
  FutureOr<void> dispose() async {
    await _cancelSubscriptions();
    await _projectNameFilterSubject.close();
    super.dispose();
  }
}
