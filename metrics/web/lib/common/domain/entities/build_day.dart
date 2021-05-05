// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a build day containing the aggregated builds data
/// for a single day.
class BuildDay extends Equatable {
  /// An identifier of the project this build day belongs to.
  final String projectId;

  /// A number of [BuildStatus.successful] builds performed during this build
  /// day.
  final int successful;

  /// A number of [BuildStatus.failed] builds performed during this build day.
  final int failed;

  /// A number of [BuildStatus.unknown] builds performed during this build day.
  final int unknown;

  /// A number of [BuildStatus.inProgress] builds ran during this build day.
  final int inProgress;

  /// A total [Duration] of [BuildStatus.successful] builds performed during
  /// this build day.
  final Duration successfulBuildsDuration;

  /// A [DateTime] that represents the date of this build day.
  final DateTime day;

  @override
  List<Object> get props => [
        projectId,
        successful,
        failed,
        unknown,
        inProgress,
        successfulBuildsDuration,
        day,
      ];

  /// Creates a new instance of the [BuildDay] with the given parameters.
  ///
  /// Throws an [ArgumentError] if any of the given parameters is `null`.
  BuildDay({
    @required this.projectId,
    @required this.successful,
    @required this.failed,
    @required this.unknown,
    @required this.inProgress,
    @required this.successfulBuildsDuration,
    @required this.day,
  }) {
    ArgumentError.checkNotNull(projectId, 'projectId');
    ArgumentError.checkNotNull(successful, 'successful');
    ArgumentError.checkNotNull(failed, 'failed');
    ArgumentError.checkNotNull(unknown, 'unknown');
    ArgumentError.checkNotNull(inProgress, 'inProgress');
    ArgumentError.checkNotNull(
        successfulBuildsDuration, 'successfulBuildsDuration');
    ArgumentError.checkNotNull(day, 'day');
  }
}
