// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';

/// A class that represents a project metrics based on the build day.
class BuildDayProjectMetrics extends Equatable {
  /// A unique identifier of the project these metrics belong to.
  final String projectId;

  /// A [BuildNumberMetric] of a project with [projectId].
  final BuildNumberMetric buildNumberMetric;

  /// A [PerformanceMetric] of a project with [projectId].
  final PerformanceMetric performanceMetric;

  @override
  List<Object> get props => [projectId, buildNumberMetric, performanceMetric];

  /// Creates a new instance of the [BuildDayProjectMetrics] with the given
  /// [projectId], [buildNumberMetric] and [performanceMetric].
  const BuildDayProjectMetrics({
    this.projectId,
    this.buildNumberMetric,
    this.performanceMetric,
  });
}
