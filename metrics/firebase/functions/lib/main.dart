// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:functions/mappers/build_day_status_field_name_mapper.dart';
import 'package:functions/models/build_day_data.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:functions/models/task_data.dart';
import 'package:functions/models/task_data_code.dart';

void main() {
  functions['onBuildAdded'] = functions.firestore
      .document('build/{buildId}')
      .onCreate(onBuildAddedHandler);
}

/// Process incrementing logic for the build days collection document,
/// based on a created build's status and started date.
Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, _) async {
  final buildData = BuildDataDeserializer.fromJson(snapshot.data.toMap());
  final startedAtUtc = _getUtcDate(buildData.startedAt);

  final mapper = BuildDayStatusFieldNameMapper();
  final buildDayStatusFieldName = mapper.map(buildData.buildStatus);

  final statusFieldIncrement = BuildDayStatusField(
    name: buildDayStatusFieldName,
    value: Firestore.fieldValues.increment(1),
  );

  final buildDayData = BuildDayData(
    projectId: buildData.projectId,
    successfulBuildsDuration: Firestore.fieldValues.increment(
      _getBuildDuration(buildData),
    ),
    day: startedAtUtc,
    statusIncrements: [statusFieldIncrement],
  );

  await _updateBuildDay(snapshot, buildDayData);
}

/// Returns a given [buildData]'s duration in milliseconds.
///
/// If the [buildData.buildStatus] is `successful`, returns a build's duration.
/// Otherwise, returns `0`.
int _getBuildDuration(BuildData buildData) {
  if (buildData.buildStatus == BuildStatus.successful) {
    return buildData.duration.inMilliseconds;
  }

  return 0;
}

//// Returns a [DateTime] representing the date in the UTC timezone created
/// from the given [dateTime].
DateTime _getUtcDate(DateTime dateTime) => dateTime.toUtc().date;

/// Updates the build day's document data with the given [data].
///
/// Adds a new document to the tasks collection if updating
/// the build day's document data fails.
Future<void> _updateBuildDay(
  DocumentSnapshot snapshot,
  BuildDayData data,
) async {
  try {
    await _setBuildDayData(snapshot, data);
  } catch (error) {
    final taskData = TaskData(
      code: TaskDataCode.buildDaysCreated.value,
      context: error.toString(),
      createdAt: Timestamp.fromDateTime(data.day),
      data: snapshot.data.toMap(),
    );

    await _addTask(snapshot, taskData);
  }
}

/// Sets the given [data] to the build day document.
///
/// If the document already exists, merges the existing data with the given one.
Future<void> _setBuildDayData(
  DocumentSnapshot snapshot,
  BuildDayData data,
) async {
  final documentId = '${data.projectId}_${data.day.millisecondsSinceEpoch}';

  await snapshot.firestore
      .collection('build_days')
      .document(documentId)
      .setData(
        DocumentData.fromMap(data.toMap()),
        SetOptions(merge: true),
      );
}

/// Adds a new document with the given [data] to the tasks collection.
Future<void> _addTask(DocumentSnapshot snapshot, TaskData data) async {
  await snapshot.firestore
      .collection('tasks')
      .add(DocumentData.fromMap(data.toMap()));
}
