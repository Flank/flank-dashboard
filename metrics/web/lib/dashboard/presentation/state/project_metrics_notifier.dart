import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/project_groups/presentation/models/project_group_model.dart';
import 'package:metrics/util/date.dart';
import 'package:rxdart/rxdart.dart';

/// The [ChangeNotifier] that holds the projects metrics data.
class ProjectMetricsNotifier extends ChangeNotifier {
  /// A [ProjectGroupDropdownItemViewModel] representing
  /// a project group with all projects.
  static const _allProjectsGroupDropdownItemViewModel =
      ProjectGroupDropdownItemViewModel(name: "All projects");

  /// Provides an ability to receive project metrics updates.
  final ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;

  /// A [Map] that holds all created [StreamSubscription].
  final Map<String, StreamSubscription> _buildMetricsSubscriptions = {};

  /// A [PublishSubject] that provides an ability to filter projects by the name.
  final _projectNameFilterSubject = PublishSubject<String>();

  /// A [Map] that holds all loaded [ProjectMetricsTileViewModel]s.
  Map<String, ProjectMetricsTileViewModel> _projectMetrics;

  /// Holds the error message that occurred during loading projects data.
  String _projectsErrorMessage;

  /// An optional filter value that represents a part (or full) project name
  /// used to limit the displayed data.
  String _projectNameFilter;

  /// Holds currently selected [ProjectGroupDropdownItemViewModel]
  ProjectGroupDropdownItemViewModel _selectedProjectGroup;

  /// Holds the list of current [ProjectModel]s.
  List<ProjectModel> _projects;

  /// Holds the list of current [ProjectGroupModel]s.
  List<ProjectGroupModel> _projectGroupModels;

  /// Holds the list of current [ProjectGroupDropdownItemViewModel]s.
  List<ProjectGroupDropdownItemViewModel> _projectGroupDropdownItems = [];

  /// Provides a list of [ProjectMetricsTileViewModel]s.
  List<ProjectGroupDropdownItemViewModel> get projectGroupDropdownItems =>
      _projectGroupDropdownItems;

  /// Provides selected [ProjectGroupDropdownItemViewModel].
  ProjectGroupDropdownItemViewModel get selectedProjectGroup =>
      _selectedProjectGroup;

  /// Indicates whether project metrics are loading or not.
  bool get isMetricsLoading {
    final List<ProjectMetricsTileViewModel> projectMetrics =
        _projectMetrics?.values?.toList();

    if (projectMetrics == null) return true;

    return projectMetrics.any((projectMetric) {
      return projectMetric.buildResultMetrics == null ||
          projectMetric.performanceSparkline == null ||
          projectMetric.buildNumberMetric == null ||
          projectMetric.coverage == null ||
          projectMetric.stability == null;
    });
  }

  /// Provides a filtered list of [ProjectMetricsTileViewModel]s.
  List<ProjectMetricsTileViewModel> get projectsMetricsTileViewModels {
    List<ProjectMetricsTileViewModel> projectsMetricsTileViewModels =
        _projectMetrics?.values?.toList();

    if (projectsMetricsTileViewModels == null) {
      return projectsMetricsTileViewModels;
    }

    if (_projectNameFilter != null) {
      projectsMetricsTileViewModels = projectsMetricsTileViewModels
          .where((project) => project.projectName
              .toLowerCase()
              .contains(_projectNameFilter.toLowerCase()))
          .toList();
    }

    if (_projectGroupModels != null) {
      projectsMetricsTileViewModels =
          _filterByProjectGroup(projectsMetricsTileViewModels);
    }

    return projectsMetricsTileViewModels;
  }

  /// Filters the [ProjectMetricsTileViewModel]s using the [selectedProjectGroup].
  List<ProjectMetricsTileViewModel> _filterByProjectGroup(
    List<ProjectMetricsTileViewModel> projectsMetricsTileViewModels,
  ) {
    final projectGroupModel = _projectGroupModels.firstWhere(
      (model) => model.id == _selectedProjectGroup?.id,
      orElse: () => null,
    );

    if (projectGroupModel == null) return projectsMetricsTileViewModels;

    return projectsMetricsTileViewModels
        .where((project) => projectGroupModel.projectIds.contains(
              project.projectId,
            ))
        .toList();
  }

  /// Provides an error description that occurred during loading metrics data.
  String get projectsErrorMessage => _projectsErrorMessage;

  /// Provides the currently applied project name filter.
  String get projectNameFilter => _projectNameFilter;

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

  /// Resets the project name filter.
  void resetProjectNameFilter() {
    _projectNameFilter = null;
  }

  /// Sets the [selectedProjectGroup] to project group with the given [id].
  void selectProjectGroup(String id) {
    final projectGroup = _projectGroupDropdownItems.firstWhere(
      (group) => group.id == id,
      orElse: () => null,
    );

    if (projectGroup == null) return;

    _selectedProjectGroup = projectGroup;

    notifyListeners();
  }

  /// Updates projects and an error message.
  Future<void> setProjects(
    List<ProjectModel> newProjects,
    String errorMessage,
  ) async {
    _projects = newProjects;
    _projectsErrorMessage = errorMessage;

    await _refreshMetricsSubscriptions();
  }

  /// Sets the current project group models.
  void setProjectGroups(List<ProjectGroupModel> projectGroupModels) {
    _projectGroupModels = projectGroupModels;

    _refreshProjectGroupDropdownItemViewModels();
  }

  /// Refreshes the project group dropdown item view models
  /// according to current project group models.
  void _refreshProjectGroupDropdownItemViewModels() {
    if (_projectGroupModels == null) {
      _projectGroupDropdownItems = null;
      _selectedProjectGroup = null;

      return;
    }

    _projectGroupDropdownItems = [
      _allProjectsGroupDropdownItemViewModel,
    ];

    _projectGroupDropdownItems.addAll(_projectGroupModels
        .map((group) => ProjectGroupDropdownItemViewModel(
              id: group.id,
              name: group.name,
            ))
        .toList());

    _selectedProjectGroup = _projectGroupDropdownItems.firstWhere(
      (group) => group.id == _selectedProjectGroup?.id,
      orElse: () => _allProjectsGroupDropdownItemViewModel,
    );

    notifyListeners();
  }

  /// Refreshes the project metrics subscriptions according to [ProjectModel]s.
  Future<void> _refreshMetricsSubscriptions() async {
    if (_projects == null) {
      await _unsubscribeFromBuildMetrics();
      notifyListeners();
      return;
    }

    final projectsMetrics = _projectMetrics ?? {};
    final projects = _projects.toList();

    final projectIds = projects.map((project) => project.id);

    projectsMetrics.removeWhere((projectId, value) {
      final remove = !projectIds.contains(projectId);
      if (remove) {
        _buildMetricsSubscriptions.remove(projectId)?.cancel();
      }

      return remove;
    });

    for (final project in projects) {
      final projectId = project.id;

      ProjectMetricsTileViewModel projectMetrics = projectsMetrics[projectId] ??
          ProjectMetricsTileViewModel(projectId: projectId);

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
  Future<void> _unsubscribeFromBuildMetrics() async {
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
    final numberOfBuilds = dashboardMetrics.buildNumberMetrics?.numberOfBuilds;

    final buildStatus = ProjectBuildStatusViewModel(
      value: dashboardMetrics.projectBuildStatusMetric?.status,
    );

    final buildNumber = BuildNumberScorecardViewModel(
      numberOfBuilds: numberOfBuilds,
    );

    projectsMetrics[projectId] = projectMetrics.copyWith(
      performanceSparkline: performanceMetrics,
      buildResultMetrics: buildResultMetrics,
      buildStatus: buildStatus,
      buildNumberMetric: buildNumber,
      coverage: CoverageViewModel(value: dashboardMetrics.coverage?.value),
      stability: StabilityViewModel(value: dashboardMetrics.stability?.value),
    );

    _projectMetrics = projectsMetrics;
    notifyListeners();
  }

  /// Creates the project performance metrics from [PerformanceMetric].
  PerformanceSparklineViewModel _getPerformanceMetrics(
    PerformanceMetric metric,
  ) {
    final performanceMetrics = metric?.buildsPerformance ?? DateTimeSet();

    if (performanceMetrics.isEmpty) {
      return PerformanceSparklineViewModel(
        performance: UnmodifiableListView([]),
      );
    }

    final buildPerformancesMap = groupBy<BuildPerformance, DateTime>(
      performanceMetrics,
      (metrics) => metrics.date.date,
    );

    final period = ReceiveProjectMetricsUpdates.buildsLoadingPeriod.inDays;
    final currentDate = DateTime.now().date;
    final performance = <Point<int>>[];

    for (int i = 0; i <= period; i++) {
      final sliceDate = currentDate.subtract(Duration(days: period - i));

      final values = buildPerformancesMap[sliceDate];

      if (values == null || values.isEmpty) {
        performance.add(Point(i, 0));
        continue;
      }

      final totalDuration = values.fold<Duration>(
        Duration.zero,
        (previous, element) {
          return previous + element.duration;
        },
      );

      final averageDuration = totalDuration ~/ values.length;
      performance.add(Point(i, averageDuration.inMilliseconds));
    }

    return PerformanceSparklineViewModel(
      performance: UnmodifiableListView(performance),
      value: metric.averageBuildDuration,
    );
  }

  /// Creates the project build result metrics from [BuildResultMetric].
  BuildResultMetricViewModel _getBuildResultMetrics(BuildResultMetric metrics) {
    final buildResults = metrics?.buildResults ?? [];

    if (buildResults.isEmpty) {
      return BuildResultMetricViewModel(
        buildResults: UnmodifiableListView([]),
      );
    }

    final buildResultViewModels = buildResults.map((result) {
      return BuildResultViewModel(
        duration: result.duration,
        date: result.date,
        url: result.url,
        buildStatus: result.buildStatus,
      );
    }).toList();

    return BuildResultMetricViewModel(
      buildResults: UnmodifiableListView(buildResultViewModels),
    );
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
