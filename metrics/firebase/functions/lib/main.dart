// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:functions/factory/build_day_status_field_factory.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/models/build_day_data.dart';
import 'package:functions/models/task_data.dart';
import 'package:functions/models/task_code.dart';

import 'models/task_data.dart';

void main() {
  functions['onBuildAdded'] = functions.firestore
      .document('build/{buildId}')
      .onCreate(onBuildAddedHandler);

  functions['onBuildUpdated'] = functions.firestore
      .document('build/{buildId}')
      .onUpdate(onBuildUpdatedHandler);
}

/// Process incrementing logic for the build days collection document,
/// based on a created build's status and started date.
Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, _) async {
  final buildData = BuildDataDeserializer.fromJson(snapshot.data.toMap());
  final startedAtDayUtc = _getUtcDay(buildData.startedAt);

  final statusFieldIncrement = BuildDayStatusFieldFactory().create(
    buildStatus: buildData.buildStatus,
    incrementCount: 1,
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

  final onErrorData = TaskData(
    code: TaskCode.buildDaysCreated,
    data: buildData.toJson(),
    createdAt: clock.now(),
  );
  final firestore = snapshot.firestore;

  await _updateBuildDay(
    firestore,
    buildDayData,
    onErrorData,
  );
}

///
Future<void> onBuildUpdatedHandler(Change<DocumentSnapshot> change, _) async {
  final oldBuild = BuildDataDeserializer.fromJson(change.before.data.toMap());
  final newBuild = BuildDataDeserializer.fromJson(change.after.data.toMap());
  final startedAtDayUtc = _getUtcDay(oldBuild.startedAt);

  // check if this build is in task
  // final isTask = _checkIfTaskExists()

  const statusFieldMapper = BuildDayStatusFieldNameMapper();
  final oldBuildDayStatusFieldName =
      statusFieldMapper.map(oldBuild.buildStatus);
  final newBuildDayStatusFieldName =
      statusFieldMapper.map(newBuild.buildStatus);

  final statusFieldDecrement = BuildDayStatusField(
    name: oldBuildDayStatusFieldName,
    value: Firestore.fieldValues.increment(-1),
  );

  final statusFieldIncrement = BuildDayStatusField(
    name: newBuildDayStatusFieldName,
    value: Firestore.fieldValues.increment(1),
  );

  final successfulBuildsDurationIncrement = Firestore.fieldValues.increment(
    _getSuccessfulBuildDuration(newBuild),
  );

  final updatedBuildDayData = BuildDayData(
    projectId: oldBuild.projectId,
    successfulBuildsDuration: successfulBuildsDurationIncrement,
    statusFields: [statusFieldDecrement, statusFieldIncrement],
    day: startedAtDayUtc,
  );

  final buildData = {
    'oldBuild': oldBuild.toJson(),
    'newBuild': newBuild.toJson(),
  };

  final onErrorData = TaskData(
    code: TaskCode.buildDaysUpdated,
    data: buildData,
    createdAt: clock.now(),
  );

  final firestore = change.after.firestore;

  await _updateBuildDay(
    firestore,
    updatedBuildDayData,
    onErrorData,
  );
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
  Firestore firestore,
  BuildDayData buildDayData,
  TaskData onErrorData,
) async {
  try {
    await _setBuildDayData(firestore, buildDayData);
  } catch (error) {
    final taskData = onErrorData.copyWith(context: error.toString());

    await _addTask(firestore, taskData);
  }
}

/// Sets the given [buildDayData] to the build day document.
///
/// If the document already exists, merges the existing data with the given one.
Future<void> _setBuildDayData(
  Firestore firestore,
  BuildDayData buildDayData,
) async {
  final documentId =
      '${buildDayData.projectId}_${buildDayData.day.millisecondsSinceEpoch}';

  await firestore.document('build_days/$documentId').setData(
        DocumentData.fromMap(buildDayData.toMap()),
        SetOptions(merge: true),
      );
}

/// Adds a new document with the given [taskData] to the tasks collection.
Future<void> _addTask(Firestore firestore, TaskData taskData) async {
  await firestore
      .collection('tasks')
      .add(DocumentData.fromMap(taskData.toMap()));
}
