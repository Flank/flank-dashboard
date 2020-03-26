import 'package:equatable/equatable.dart';
import 'package:metrics_core/src/entities/build_status.dart';
import 'package:metrics_core/src/entities/percent.dart';

/// Represents a single finished build from CI.
class Build extends Equatable {
  final String id;
  final DateTime startedAt;
  final BuildStatus buildStatus;
  final Duration duration;
  final String workflowName;
  final String url;
  final Percent coverage;

  /// Creates the [Build].
  ///
  /// [id] is the unique identifier of this build.
  /// [startedAt] is the date and time this build was started at.
  /// [buildStatus] is the resulting status of this build.
  /// [duration] is the duration of this build.
  /// [workflowName] is the name of the workflow that was used to run the build.
  /// [url] is the URL of the source control revision used to run the build.
  /// [coverage] is the project test coverage percent of this build.
  const Build({
    this.id,
    this.startedAt,
    this.buildStatus,
    this.duration,
    this.workflowName,
    this.url,
    this.coverage,
  });

  @override
  List<Object> get props => [startedAt, buildStatus, duration, workflowName];
}
