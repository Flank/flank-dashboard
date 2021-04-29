// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:metrics/common/domain/entities/build_day.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [BuildDay] entity.
class BuildDayData extends BuildDay implements DataModel {
  /// Creates a new instance of the [BuildDayData] with the
  /// given parameters.
  ///
  /// Throws an [ArgumentError] if any of the given parameters is `null`.
  BuildDayData({
    @required String projectId,
    @required int successful,
    @required int failed,
    @required int unknown,
    @required int inProgress,
    @required Duration totalDuration,
    @required DateTime day,
  }) : super(
          projectId: projectId,
          successful: successful,
          failed: failed,
          unknown: unknown,
          inProgress: inProgress,
          totalDuration: totalDuration,
          day: day,
        );

  /// Creates a new instance of the [BuildDayData] from the given [json].
  ///
  /// Returns `null` if the given [json] is null.
  factory BuildDayData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final numberOfSuccessfulBuilds = json['successful'] as int;
    final numberOfFailedBuilds = json['failed'] as int;
    final numberOfUnknownBuilds = json['unknown'] as int;
    final numberOfInProgressBuilds = json['inProgress'] as int;

    final totalDurationInMilliseconds = json['totalDuration'] as int;

    final dayTimestamp = json['day'] as Timestamp;

    return BuildDayData(
      projectId: json['projectId'] as String,
      successful: numberOfSuccessfulBuilds ?? 0,
      failed: numberOfFailedBuilds ?? 0,
      unknown: numberOfUnknownBuilds ?? 0,
      inProgress: numberOfInProgressBuilds ?? 0,
      totalDuration: Duration(milliseconds: totalDurationInMilliseconds ?? 0),
      day: dayTimestamp.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'successful': successful,
      'failed': failed,
      'unknown': unknown,
      'inProgress': inProgress,
      'totalDuration': totalDuration.inMilliseconds,
      'day': Timestamp.fromDate(day),
    };
  }
}
