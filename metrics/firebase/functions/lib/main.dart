// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';

void main() {
  functions['onBuildAdded'] = functions.firestore
      .document('build/{buildId}')
      .onCreate(onBuildAddedHandler);
}

/// Process incrementing logic for the build days collection document,
/// based on a created build's status and started date.
Future<void> onBuildAddedHandler(DocumentSnapshot snapshot, _) async {
  final buildData = snapshot.data;
  final buildStartedAt = buildData.getTimestamp('startedAt');
  final buildDuration = _getDuration(buildData);
  final projectId = buildData.getString('projectId');
  final dateInUTC = _getDateInUTC(buildStartedAt);
  final buildDayStatusFieldName = _getBuildDayStatusFieldName(buildData);
  final documentId = '${projectId}_${dateInUTC.millisecondsSinceEpoch}';

  try {
    final data = {
      'projectId': projectId,
      buildDayStatusFieldName: _incrementField(1),
      'totalDuration': _incrementField(buildDuration),
      'day': Timestamp.fromDateTime(dateInUTC),
    };

    await snapshot.firestore
        .collection('build_days')
        .document(documentId)
        .setData(
          DocumentData.fromMap(data),
          SetOptions(merge: true),
        );
  } catch (error) {
    await _addTask('build_days_created', snapshot, error.toString(), dateInUTC);
  }
}

/// Returns a duration value from the given [documentData].
///
/// If the duration is `null` returns `0`.
int _getDuration(DocumentData documentData) {
  int duration = documentData.getInt('duration');

  if (duration == null) return 0;

  return duration;
}

/// Returns a [DateTime] in UTC from the given [timestamp].
DateTime _getDateInUTC(Timestamp timestamp) {
  final dateTime = timestamp.toDateTime().toUtc();

  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
}

/// Returns a build day field name, based on the build status from
/// the given [buildData].
String _getBuildDayStatusFieldName(DocumentData documentData) {
  final buildStatus = documentData.getString('buildStatus');

  return buildStatus.split('.').last;
}

/// Returns [FieldValue] that tells the server to increment
/// the field's current value by the given [value].
FieldValue _incrementField(int value) {
  return Firestore.fieldValues.increment(value);
}

/// Creates a new document in the tasks collection with the given parameters.
Future<void> _addTask(
  String code,
  DocumentSnapshot snapshot,
  String error,
  DateTime day,
) async {
  final taskData = {
    'code': code,
    'data': snapshot.data.toMap(),
    'context': error,
    'createdAt': day,
  };

  await snapshot.firestore
      .collection('tasks')
      .add(DocumentData.fromMap(taskData));
}
