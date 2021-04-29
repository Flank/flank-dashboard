// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:meta/meta.dart';

/// A class that represents a build day to save in the [Firestore].
class BuildDayData {
  /// An identifier of the project this build day relates to.
  final String projectId;

  /// A [DateTime] that represents the day start this build day aggregation
  /// belongs to.
  final DateTime day;

  /// A total builds duration.
  final FieldValue totalDuration;

  /// A [List] of [BuildDayStatusField]s, a [Firestore] increment applies to.
  final List<BuildDayStatusField> statusIncrements;

  /// Creates a new instance of the [BuildDayData] with the given parameters.
  ///
  /// Throws an [ArgumentError] if either [projectId] or [day] is `null`.
  BuildDayData({
    @required this.projectId,
    @required this.day,
    this.totalDuration,
    this.statusIncrements,
  }) {
    ArgumentError.checkNotNull(projectId, 'projectId');
    ArgumentError.checkNotNull(day, 'day');
  }

  /// Converts this [BuildDayData] into the [Map].
  Map<String, dynamic> toMap() {
    final statusIncrementsMap = {};

    statusIncrements.forEach((status) {
      statusIncrementsMap.addAll(status.toMap());
    });

    return {
      'projectId': projectId,
      'day': Timestamp.fromDateTime(day),
      'totalDuration': totalDuration,
      ...statusIncrementsMap,
    };
  }
}
