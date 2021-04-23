import 'package:meta/meta.dart';

/// A class that represents a build day.
@immutable
class BuildDay {
  /// An identifier of the project this build day belongs to.
  final String projectId;

  /// A number of successful builds performed during this build day.
  final int successful;

  /// A number of failed builds performed during this build day.
  final int failed;

  /// A number of unknown status builds performed during this build day.
  final int unknown;

  /// A number of in-progress builds ran during this build day.
  final int inProgress;

  /// A total amount of time taken for builds during this build day.
  final Duration totalDuration;

  /// A [DateTime] that represents the date of this build day.
  final DateTime day;

  /// Creates a new instance of the [BuildDay].
  BuildDay({
    @required this.projectId,
    this.successful,
    this.failed,
    this.unknown,
    this.inProgress,
    this.totalDuration,
    this.day,
  }) {
    ArgumentError.checkNotNull(projectId, 'projectId');
    ArgumentError.checkNotNull(successful, 'successful');
    ArgumentError.checkNotNull(failed, 'failed');
    ArgumentError.checkNotNull(unknown, 'unknown');
    ArgumentError.checkNotNull(inProgress, 'inProgress');
    ArgumentError.checkNotNull(totalDuration, 'totalDuration');
    ArgumentError.checkNotNull(day, 'day');
  }
}
