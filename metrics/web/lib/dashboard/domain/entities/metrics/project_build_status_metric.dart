// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a project build status metric.
class ProjectBuildStatusMetric extends Equatable {
  /// Provides an information about the status of the project build.
  final BuildStatus status;

  @override
  List<Object> get props => [status];

  /// Creates a [ProjectBuildStatusMetric] with the given [status].
  const ProjectBuildStatusMetric({this.status});
}
