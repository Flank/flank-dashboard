// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/injector/widget/page_parameters_dispatcher.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/dashboard_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates.dart';
import 'package:metrics/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/date_range_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/project_groups/presentation/models/project_group_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rxdart/rxdart.dart';

/// The [ChangeNotifier] that holds the projects metrics data.
class ProjectMetricsNotifier extends PageNotifier {
  /// A [ProjectGroupDropdownItemViewModel] representing
  /// a project group with all projects.
  static const _allProjectsGroupDropdownItemViewModel =
      ProjectGroupDropdownItemViewModel(name: "All projects");

  /// A [ReceiveProjectMetricsUpdates] that provides an ability to receive
  /// project metrics updates.
  final ReceiveProjectMetricsUpdates _receiveProjectMetricsUpdates;

  /// A [ReceiveBuildDayProjectMetricsUpdates] that provides an ability to
  /// receive build day updates.
  final ReceiveBuildDayProjectMetricsUpdates _receiveBuildDayUpdates;

  /// A [Map] that holds all created project metrics [StreamSubscription]s.
  final Map<String, StreamSubscription> _buildMetricsSubscriptions = {};

  /// A [Map] that holds all created build day project metrics
  /// [StreamSubscription]s.
  final Map<String, StreamSubscription> _buildDaySubscriptions = {};

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
      projectsMetricsTileViewModels = _filterByProjectGroup(
        projectsMetricsTileViewModels,
      );
    }

    return projectsMetricsTileViewModels;
  }

  /// Provides an error description that occurred during loading metrics data.
  String get projectsErrorMessage => _projectsErrorMessage;

  /// Provides the currently applied project name filter.
  String get projectNameFilter => _projectNameFilter;

  /// Creates a new instance of the [ProjectMetricsNotifier] with the given
  /// parameters.
  ///
  /// Throws an [AssertionError] if the given [ReceiveProjectMetricsUpdates]
  /// or [ReceiveBuildDayProjectMetricsUpdates] is `null`.
  ProjectMetricsNotifier(
    this._receiveProjectMetricsUpdates,
    this._receiveBuildDayUpdates,
  )   : assert(
          _receiveProjectMetricsUpdates != null,
          'The ReceiveProjectMetricsUpdates must not be null',
        ),
        assert(
          _receiveBuildDayUpdates != null,
          'The ReceiveBuildDayProjectMetricsUpdates must not be null',
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

    _pageParametersUpdatesStream.add(_currentPageParameters.copyWith(
      selectedProjectGroup: _selectedProjectGroup?.id,
    ));

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

    _applyPageParameters(_currentPageParameters);

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
        _buildDaySubscriptions.remove(projectId)?.cancel();
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
        _subscribeToBuildDayMetrics(projectId);
      }

      projectsMetrics[projectId] = projectMetrics;
    }

    _updateProjectMetrics(projectsMetrics);
  }

  /// Unsubscribes from project metrics.
  Future<void> _unsubscribeFromBuildMetrics() async {
    await _cancelSubscriptions();
    notifyListeners();
  }

  /// Subscribes to updates of the [BuildDayProjectMetrics] of the project with
  /// the given [projectId].
  void _subscribeToBuildDayMetrics(String projectId) {
    final buildDayMetricsStream = _receiveBuildDayUpdates(
      ProjectIdParam(projectId),
    );

    _buildDaySubscriptions[projectId] = buildDayMetricsStream.listen(
      (metrics) => _processBuildDayProjectMetrics(metrics, projectId),
      onError: _projectsErrorHandler,
    );
  }

  /// Creates project metrics for project with the given [projectId] using the
  /// given [buildDayProjectMetrics].
  void _processBuildDayProjectMetrics(
    BuildDayProjectMetrics buildDayProjectMetrics,
    String projectId,
  ) {
    final projectMetrics = _projectMetrics ?? {};
    final currentProjectMetrics = projectMetrics[projectId];

    if (currentProjectMetrics == null || buildDayProjectMetrics == null) return;

    final performanceMetrics = _getPerformanceSparklineViewModel(
      buildDayProjectMetrics.performanceMetric,
    );

    final buildNumber = _getBuildNumberScorecardViewModel(
      buildDayProjectMetrics.buildNumberMetric,
    );

    projectMetrics[projectId] = currentProjectMetrics.copyWith(
      performanceSparkline: performanceMetrics,
      buildNumberMetric: buildNumber,
    );

    _updateProjectMetrics(projectMetrics);
  }

  /// Creates a [PerformanceSparklineViewModel] from the given
  /// [performanceMetric].
  PerformanceSparklineViewModel _getPerformanceSparklineViewModel(
    PerformanceMetric performanceMetric,
  ) {
    final performanceMetrics =
        performanceMetric?.buildsPerformance ?? DateTimeSet();

    UnmodifiableListView<Point<int>> performancePoints = UnmodifiableListView(
      [],
    );
    if (performanceMetrics.isNotEmpty) {
      performancePoints = _createPerformancePoints(performanceMetrics);
    }

    return PerformanceSparklineViewModel(
      value: performanceMetric?.averageBuildDuration ?? Duration.zero,
      performance: performancePoints,
    );
  }

  /// Creates a [PerformanceSparklineViewModel.performance] from the given
  /// [performance].
  UnmodifiableListView<Point<int>> _createPerformancePoints(
    DateTimeSet<BuildPerformance> performance,
  ) {
    final performanceMap = performance.groupFoldBy(
      (buildPerformance) => buildPerformance.date.date,
      (_, buildPerformance) => buildPerformance.duration.inMilliseconds,
    );

    final performancePoints = <Point<int>>[];
    final currentDate = DateTime.now().date;
    final loadingPeriod =
        ReceiveBuildDayProjectMetricsUpdates.metricsLoadingPeriod.inDays;

    for (int i = 0; i <= loadingPeriod; i++) {
      final subtractDuration = Duration(days: loadingPeriod - i);
      final sliceDate = currentDate.subtract(subtractDuration);

      final averageDuration = performanceMap[sliceDate] ?? 0;

      performancePoints.add(Point(i, averageDuration));
    }

    return UnmodifiableListView(performancePoints);
  }

  /// Creates a [BuildNumberScorecardViewModel] from the given
  /// [buildNumberMetric].
  BuildNumberScorecardViewModel _getBuildNumberScorecardViewModel(
    BuildNumberMetric buildNumberMetric,
  ) {
    return BuildNumberScorecardViewModel(
      numberOfBuilds: buildNumberMetric?.numberOfBuilds,
    );
  }

  /// Subscribes to project metrics.
  void _subscribeToBuildMetrics(String projectId) {
    final dashboardMetricsStream = _receiveProjectMetricsUpdates(
      ProjectIdParam(projectId),
    );

    _buildMetricsSubscriptions[projectId] = dashboardMetricsStream.listen(
      (metrics) => _createProjectMetrics(metrics, projectId),
      onError: _projectsErrorHandler,
    );
  }

  /// Creates project metrics from the [DashboardProjectMetrics].
  void _createProjectMetrics(
    DashboardProjectMetrics dashboardMetrics,
    String projectId,
  ) {
    final projectsMetrics = _projectMetrics ?? {};

    final projectMetrics = projectsMetrics[projectId];

    if (projectMetrics == null || dashboardMetrics == null) return;

    final buildResultMetrics = _getBuildResultMetrics(
      dashboardMetrics.buildResultMetrics,
    );

    final buildStatus = ProjectBuildStatusViewModel(
      value: dashboardMetrics.projectBuildStatusMetric?.status,
    );

    projectsMetrics[projectId] = projectMetrics.copyWith(
      buildResultMetrics: buildResultMetrics,
      buildStatus: buildStatus,
      coverage: CoverageViewModel(value: dashboardMetrics.coverage?.value),
      stability: StabilityViewModel(value: dashboardMetrics.stability?.value),
    );

    _updateProjectMetrics(projectsMetrics);
  }

  /// Creates the project build result metrics from [BuildResultMetric].
  BuildResultMetricViewModel _getBuildResultMetrics(BuildResultMetric metrics) {
    final buildResults = metrics?.buildResults ?? [];

    if (buildResults.isEmpty) {
      return BuildResultMetricViewModel(
        buildResults: UnmodifiableListView([]),
      );
    }

    const numberOfBuildsToDisplay =
        ReceiveProjectMetricsUpdates.buildsToLoadForChartMetrics;
    final buildsCount = buildResults.length;

    List<BuildResult> latestBuildResults = buildResults;
    if (buildsCount >= numberOfBuildsToDisplay) {
      latestBuildResults = latestBuildResults.sublist(
        buildsCount - numberOfBuildsToDisplay,
      );
    }

    final maxBuildDuration = _getMaxBuildDuration(latestBuildResults);

    final buildResultViewModels =
        latestBuildResults.map(_createBuildResultViewModel).toList();

    final dateRange = DateRangeViewModel(
      start: buildResultViewModels.first.date,
      end: buildResultViewModels.last.date,
    );

    return BuildResultMetricViewModel(
      buildResults: UnmodifiableListView(buildResultViewModels),
      maxBuildDuration: maxBuildDuration,
      dateRangeViewModel: dateRange,
    );
  }

  /// Returns a maximum [BuildResult.duration] from the given [buildResults].
  ///
  /// Returns `null` if the given [buildResults] doesn't contain a [BuildResult]
  /// with the non-null duration.
  Duration _getMaxBuildDuration(List<BuildResult> buildResults) {
    final buildDurations = buildResults
        .where((result) => result.duration != null)
        .map((result) => result.duration);

    Duration maxDuration;
    for (final duration in buildDurations) {
      if (maxDuration == null || maxDuration < duration) {
        maxDuration = duration;
      }
    }

    return maxDuration;
  }

  /// Creates a specific [BuildResultViewModel] from the given [result]
  /// depending on the [BuildResult.buildStatus].
  ///
  /// Returns an [InProgressBuildResultViewModel] if the given
  /// [BuildResult.buildStatus] is the [BuildStatus.inProgress].
  ///
  /// Otherwise, returns a [FinishedBuildResultViewModel].
  BuildResultViewModel _createBuildResultViewModel(BuildResult result) {
    final popupViewModel = BuildResultPopupViewModel(
      date: result.date,
      duration: result.duration,
      buildStatus: result.buildStatus,
    );

    if (result.buildStatus == BuildStatus.inProgress) {
      return InProgressBuildResultViewModel(
        buildResultPopupViewModel: popupViewModel,
        date: result.date,
        url: result.url,
      );
    }

    return FinishedBuildResultViewModel(
      duration: result.duration,
      buildResultPopupViewModel: popupViewModel,
      date: result.date,
      url: result.url,
      buildStatus: result.buildStatus,
    );
  }

  /// Updates the [_projectMetrics] value with the given [projectsMetrics].
  void _updateProjectMetrics(
    Map<String, ProjectMetricsTileViewModel> projectsMetrics,
  ) {
    _projectMetrics = projectsMetrics;
    notifyListeners();
  }

  /// Cancels all created subscriptions.
  Future<void> _cancelSubscriptions() async {
    for (final subscription in _buildMetricsSubscriptions.values) {
      await subscription?.cancel();
    }
    for (final subscription in _buildDaySubscriptions.values) {
      await subscription?.cancel();
    }

    _projectMetrics = null;
    _buildMetricsSubscriptions.clear();
    _buildDaySubscriptions.clear();
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

  DashboardPageParameters _currentPageParameters;
  final _pageParametersUpdatesStream =
      BehaviorSubject<DashboardPageParameters>();

  @override
  // TODO: implement pageParametersUpdatesStream
  Stream<PageParameters> get pageParametersUpdatesStream =>
      _pageParametersUpdatesStream;

  @override
  void handlePageParameters(PageParameters parameters) {
    if (parameters is DashboardPageParameters) {
      if (isMetricsLoading) {
        _currentPageParameters = parameters;
        return;
      }

      _applyPageParameters(parameters);
    }
  }

  void _applyPageParameters(DashboardPageParameters dashboardPageParameters) {
    final selectedProjectGroup = dashboardPageParameters.selectedProjectGroup;

    final projectGroupExists = _projectGroupModels.any(
      (projectGroupModel) => projectGroupModel.id == selectedProjectGroup,
    );
    final projectGroupId = projectGroupExists
        ? selectedProjectGroup
        : _allProjectsGroupDropdownItemViewModel.id;

    selectProjectGroup(projectGroupId);
  }
}
