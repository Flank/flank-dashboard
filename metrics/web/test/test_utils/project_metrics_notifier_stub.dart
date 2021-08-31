// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/models/project_model.dart';
import 'package:metrics/dashboard/presentation/models/dashboard_page_parameters_model.dart';
import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/project_groups/presentation/models/project_group_model.dart';

/// Stub implementation of the [ProjectMetricsNotifier].
///
/// Provides test implementation of the [ProjectMetricsNotifier] methods.
class ProjectMetricsNotifierStub extends ChangeNotifier
    implements ProjectMetricsNotifier {
  final _testProjectMetrics = ProjectMetricsTileViewModel(
    projectId: '1',
    projectName: 'project',
    coverage: const CoverageViewModel(value: 0.1),
    stability: const StabilityViewModel(value: 0.2),
    buildNumberMetric: const BuildNumberScorecardViewModel(numberOfBuilds: 0),
    performanceSparkline: PerformanceSparklineViewModel(
      performance: UnmodifiableListView([]),
    ),
    buildResultMetrics: BuildResultMetricViewModel(
      buildResults: UnmodifiableListView([]),
    ),
  );

  @override
  List<ProjectGroupDropdownItemViewModel> get projectGroupDropdownItems =>
      const [
        ProjectGroupDropdownItemViewModel(name: 'All projects'),
      ];

  @override
  ProjectGroupDropdownItemViewModel get selectedProjectGroup => null;

  /// The list of [ProjectMetricsTileViewModel]s.
  final List<ProjectMetricsTileViewModel> _projectMetrics;

  /// Creates the [ProjectMetricsNotifierStub] with the given [projectsMetrics].
  ///
  /// If [projectsMetrics] is not passed or the `null`
  /// is passed the list containing [_testProjectMetrics] used.
  ProjectMetricsNotifierStub({
    List<ProjectMetricsTileViewModel> projectsMetrics,
  }) : _projectMetrics = projectsMetrics;

  @override
  List<ProjectMetricsTileViewModel> get projectsMetricsTileViewModels =>
      _projectMetrics ?? [_testProjectMetrics];

  @override
  String get projectsErrorMessage => null;

  @override
  void filterByProjectName(String value) {}

  @override
  Future<void> setProjects(
      List<ProjectModel> newProjectModels, String projectErrorMessage) async {
    return;
  }

  @override
  void setProjectGroups(List<ProjectGroupModel> projectGroupModels) {}

  @override
  void selectProjectGroup(String id) {}

  @override
  String get projectNameFilter => null;

  @override
  bool get isMetricsLoading => false;

  @override
  DashboardPageParametersModel get pageParameters => null;

  @override
  void handlePageParameters(PageParametersModel parameters) {}

  @override
  void handlePageParametersOnQuit(PageParametersModel parameters){}
}
