// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a build day.
class BuildDay extends Equatable {
  /// An identifier of the project this build day belongs to.
  final String projectId;

  /// A number of [BuildStatus.successful] builds performed during this build
  /// day.
  final int successful;

  /// A number of failed builds performed during this build day.
  final int failed;

  /// A number of [BuildStatus.unknown] builds performed during this build day.
  final int unknown;

  /// A number of in-progress builds ran during this build day.
  final int inProgress;

  /// A total [Duration] taken for builds during this build day.
  final Duration totalDuration;

  /// A [DateTime] that represents the date of this build day.
  final DateTime day;

  /// Creates a new instance of the [BuildDay].
  BuildDay({
    @required this.projectId,
    @required this.successful,
    @required this.failed,
    @required this.unknown,
    @required this.inProgress,
    @required this.totalDuration,
    @required this.day,
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
