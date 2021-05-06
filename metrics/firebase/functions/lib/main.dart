// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:functions/mappers/build_day_status_field_name_mapper.dart';
import 'package:functions/models/build_day_data.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:functions/models/task_data.dart';
import 'package:functions/models/task_code.dart';

void main() {
  functions['onBuildAdded'] = functions.firestore
      .document('build/{buildId}')
      .onCreate(onBuildAddedHandler);
}

/// Process incrementing logic for the build days collection document,
/// based on a created build's status and started date.
Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, _) async {
  final buildData = BuildDataDeserializer.fromJson(snapshot.data.toMap());
  final startedAtDayUtc = _getUtcDay(buildData.startedAt);

  final statusFieldMapper = BuildDayStatusFieldNameMapper();
  final buildDayStatusFieldName = statusFieldMapper.map(buildData.buildStatus);

  final statusFieldIncrement = BuildDayStatusField(
    name: buildDayStatusFieldName,
    value: Firestore.fieldValues.increment(1),
  );

  final successfulBuildsDurationIncrement = Firestore.fieldValues.increment(
    _getSuccessfulBuildDuration(buildData),
  );

  final buildDayData = BuildDayData(
    projectId: buildData.projectId,
    successfulBuildsDuration: successfulBuildsDurationIncrement,
    day: startedAtDayUtc,
    statusFields: [statusFieldIncrement],
  );

  await _updateBuildDay(snapshot, buildDayData);
}

/// Returns a given [buildData]'s duration in milliseconds.
///
/// If the given [buildData] is `successful`, returns it's duration.
/// Otherwise, returns `0`.
int _getSuccessfulBuildDuration(BuildData buildData) {
  if (buildData.buildStatus == BuildStatus.successful) {
    return buildData.duration.inMilliseconds;
  }

  return 0;
}

/// Returns a [DateTime] representing the day in the UTC timezone created
/// from the given [dateTime].
DateTime _getUtcDay(DateTime dateTime) => dateTime.toUtc().date;

/// Updates the build day's document data with the given [buildDayData].
///
/// Adds a new document to the tasks collection if updating
/// the build day's document data fails.
Future<void> _updateBuildDay(
  DocumentSnapshot snapshot,
  BuildDayData buildDayData,
) async {
  try {
    await _setBuildDayData(snapshot, buildDayData);
  } catch (error) {
    final taskData = TaskData(
      code: TaskCode.buildDaysCreated,
      context: error.toString(),
      createdAt: clock.now(),
      data: snapshot.data.toMap(),
    );

    await _addTask(snapshot, taskData);
  }
}

/// Sets the given [buildDayData] to the build day document.
///
/// If the document already exists, merges the existing data with the given one.
Future<void> _setBuildDayData(
  DocumentSnapshot snapshot,
  BuildDayData buildDayData,
) async {
  final documentId =
      '${buildDayData.projectId}_${buildDayData.day.millisecondsSinceEpoch}';

  await snapshot.firestore.document('build_days/$documentId').setData(
        DocumentData.fromMap(buildDayData.toMap()),
        SetOptions(merge: true),
      );
}

/// Adds a new document with the given [taskData] to the tasks collection.
Future<void> _addTask(DocumentSnapshot snapshot, TaskData taskData) async {
  await snapshot.firestore
      .collection('tasks')
      .add(DocumentData.fromMap(taskData.toMap()));
}
