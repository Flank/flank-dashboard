// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/factory/build_day_status_field_factory.dart';
import 'package:functions/models/document_change_data.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:functions/models/build_day_data.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:functions/models/task_data.dart';
import 'package:functions/models/task_code.dart';

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
  final buildDayStatusFieldFactory = BuildDayStatusFieldFactory();
  final buildData = BuildDataDeserializer.fromJson(snapshot.data.toMap());
  final startedAtDayUtc = _getUtcDay(buildData.startedAt);
  final firestore = snapshot.firestore;

  final statusFieldIncrement = buildDayStatusFieldFactory.create(
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

  final errorTaskData = TaskData(
    code: TaskCode.buildDaysCreated,
    data: buildData.toJson(),
    createdAt: clock.now(),
  );

  await _updateBuildDay(
    firestore,
    buildDayData: buildDayData,
    errorTaskData: errorTaskData,
  );
}

/// Process incrementing and decrementing logic for the build days collection
/// document, based on a updated build's status and started date.
Future<void> onBuildUpdatedHandler(Change<DocumentSnapshot> change, _) async {
  final buildDayStatusFieldFactory = BuildDayStatusFieldFactory();
  final beforeBuild = BuildDataDeserializer.fromJson(
    change.before.data.toMap(),
  );
  final afterBuild = BuildDataDeserializer.fromJson(change.after.data.toMap());
  final startedAtDayUtc = _getUtcDay(afterBuild.startedAt);
  final firestore = change.after.firestore;
  final statusFields = <BuildDayStatusField>[];

  if (beforeBuild.buildStatus == afterBuild.buildStatus) return;

  final task = await _getBuildTask(firestore, afterBuild);

  if (task == null) {
    final statusFieldDecrement = buildDayStatusFieldFactory.create(
      buildStatus: beforeBuild.buildStatus,
      incrementCount: -1,
    );
    statusFields.add(statusFieldDecrement);
  }

  final statusFieldIncrement = buildDayStatusFieldFactory.create(
    buildStatus: afterBuild.buildStatus,
    incrementCount: 1,
  );
  statusFields.add(statusFieldIncrement);

  final successfulDurationChange = _getSuccessfulDurationChange(
    beforeBuild,
    afterBuild,
  );
  final successfulBuildsDurationIncrement = Firestore.fieldValues.increment(
    successfulDurationChange,
  );

  final updatedBuildDayData = BuildDayData(
    projectId: afterBuild.projectId,
    successfulBuildsDuration: successfulBuildsDurationIncrement,
    statusFields: statusFields,
    day: startedAtDayUtc,
  );

  final documentChangeData = DocumentChangeData(
    beforeUpdateData: beforeBuild,
    afterUpdateData: afterBuild,
  );

  final errorTaskData = TaskData(
    code: TaskCode.buildDaysUpdated,
    data: documentChangeData.toJson(),
    createdAt: clock.now(),
  );

  final isUpdated = await _updateBuildDay(
    firestore,
    buildDayData: updatedBuildDayData,
    errorTaskData: errorTaskData,
  );

  if (isUpdated && task != null) await _deleteTask(firestore, task.documentID);
}

/// Returns a difference between [beforeBuild]'s and [afterBuild]'s
/// successful duration.
int _getSuccessfulDurationChange(BuildData beforeBuild, BuildData afterBuild) {
  final successfulBeforeBuildDuration = _getSuccessfulBuildDuration(
    beforeBuild,
  );
  final successfulAfterBuildDuration = _getSuccessfulBuildDuration(afterBuild);

  return successfulAfterBuildDuration - successfulBeforeBuildDuration;
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
/// Returns `true` if setting the given [buildDayData] to the build day
/// document is successful. Otherwise, returns `false`.
///
/// Adds a new document with the given [errorTaskData] to the tasks collection
/// if updating the build day's document data fails.
///
/// Throws an [ArgumentError] if either [buildDayData] or
/// [errorTaskData] is `null`.
Future<bool> _updateBuildDay(
  Firestore firestore, {
  BuildDayData buildDayData,
  TaskData errorTaskData,
}) async {
  ArgumentError.checkNotNull(buildDayData, 'buildDayData');
  ArgumentError.checkNotNull(errorTaskData, 'errorTaskData');

  try {
    await _setBuildDayData(firestore, buildDayData);

    return true;
  } catch (error) {
    final taskData = errorTaskData.copyWith(context: error.toString());
    await _addTask(firestore, taskData);

    return false;
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

/// Returns a [TaskCode.buildDaysCreated] task that belongs to
/// the given [buildData].
///
/// Returns `null` if the task is not found.
Future<DocumentSnapshot> _getBuildTask(
  Firestore firestore,
  BuildData buildData,
) async {
  final snapshot = await firestore
      .collection('tasks')
      .where('data.projectId', isEqualTo: buildData.projectId)
      .where('data.buildNumber', isEqualTo: buildData.buildNumber)
      .where('code', isEqualTo: TaskCode.buildDaysCreated.value)
      .get();
  final documents = snapshot.documents;

  if (documents.isEmpty) return null;

  return documents.first;
}

/// Deletes a task document specified by the given [documentId].
Future<void> _deleteTask(Firestore firestore, String documentId) async {
  await firestore.document('tasks/$documentId').delete();
}
