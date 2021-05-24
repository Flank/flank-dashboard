// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/project_build_status_metric.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represent the main project metrics available for users
/// to have a quick understanding of project status.
class DashboardProjectMetrics extends Equatable {
  /// A unique identifier of the project these metrics belong to.
  final String projectId;

  /// A status of the build of the project these metrics belong to.
  final ProjectBuildStatusMetric projectBuildStatusMetric;

  /// A [BuildResultMetric] of project with [projectId].
  final BuildResultMetric buildResultMetrics;

  /// A test coverage percent of the project with [projectId].
  final Percent coverage;

  /// A percentage of successful builds to loaded builds.
  final Percent stability;

  @override
  List<Object> get props => [
        projectId,
        projectBuildStatusMetric,
        buildResultMetrics,
        coverage,
        stability,
      ];

  /// Creates the [DashboardProjectMetrics].
  const DashboardProjectMetrics({
    this.projectId,
    this.projectBuildStatusMetric,
    this.buildResultMetrics,
    this.coverage,
    this.stability,
  });
}
