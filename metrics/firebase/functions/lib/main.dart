// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/data/build_day_data.dart';
import 'package:functions/data/build_day_status_field.dart';
import 'package:functions/data/task_data.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:functions/mappers/build_day_status_field_name_mapper.dart';

void main() {
  functions['onBuildAdded'] = functions.firestore
      .document('build/{buildId}')
      .onCreate(onBuildAddedHandler);
}

/// Process incrementing logic for the build days collection document,
/// based on a created build's status and started date.
Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, _) async {
  final buildData = BuildDataDeserializer.fromJson(snapshot.data.toMap());
  final utcDate = _getDateInUTC(buildData.startedAt);

  final mapper = BuildDayStatusFieldNameMapper();
  final buildDayStatusFieldName = mapper.map(buildData.buildStatus);

  final documentId = '${buildData.projectId}_${utcDate.millisecondsSinceEpoch}';

  final statusField = BuildDayStatusField(
    name: buildDayStatusFieldName,
    value: Firestore.fieldValues.increment(1),
  );

  final buildDayData = BuildDayData(
    projectId: buildData.projectId,
    totalDuration: Firestore.fieldValues.increment(
      buildData.duration.inMilliseconds,
    ),
    day: Timestamp.fromDateTime(utcDate),
    statusField: statusField,
  );

  try {
    await _setBuildDay(snapshot, documentId, buildDayData);
  } catch (error) {
    final taskData = TaskData(
      code: 'build_days_created',
      context: error.toString(),
      day: Timestamp.fromDateTime(utcDate),
      data: snapshot.data.toMap(),
    );

    await _addTask(snapshot, taskData);
  }
}

/// Returns a [DateTime] in UTC from the given [dateTime].
///
/// The return [DateTime] has a default time.
DateTime _getDateInUTC(DateTime dateTime) {
  final utcDate = dateTime.toUtc();

  return DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
}

/// Writes a new document in the build days collection with the given parameters.
Future<void> _setBuildDay(
  DocumentSnapshot snapshot,
  String documentId,
  BuildDayData data,
) async {
  await snapshot.firestore
      .collection('build_days')
      .document(documentId)
      .setData(
        DocumentData.fromMap(data.toMap()),
        SetOptions(merge: true),
      );
}

/// Creates a new document in the tasks collection with the given parameters.
Future<void> _addTask(DocumentSnapshot snapshot, TaskData data) async {
  await snapshot.firestore
      .collection('tasks')
      .add(DocumentData.fromMap(data.toMap()));
}
