import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a project build status metrics.
class ProjectBuildStatusMetrics extends Equatable {
  /// Provides an information about the status of the project build.
  final BuildStatus status;

  @override
  List<Object> get props => [status];

  /// Creates a [ProjectBuildStatusMetrics] with the given [status].
  const ProjectBuildStatusMetrics({this.status});
}
