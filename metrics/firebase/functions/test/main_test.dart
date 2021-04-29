// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../lib/main.dart';
import '../lib/mappers/build_day_status_field_name_mapper.dart';

void main() {
  group(("onBuildAddedHandler"), () {
    const buildDaysCollectionName = 'build_days';
    const tasksCollectionName = 'tasks';
    const projectId = 'projectId';
    const durationInMilliseconds = 123;
    final startedAt = DateTime.now();
    final startedAtUtc = _getUtcDate(startedAt);
    final buildStatus = BuildStatus.successful;

    final build = {
      'duration': durationInMilliseconds,
      'projectId': projectId,
      'buildStatus': buildStatus.toString(),
      'startedAt': Timestamp.fromDateTime(startedAt),
      'url': 'url',
      'workflowName': 'workflowName',
    };

    final mapper = BuildDayStatusFieldNameMapper();
    final buildDayStatusFieldName = mapper.map(buildStatus);

    final expectedBuildDayData = {
      'projectId': projectId,
      buildDayStatusFieldName: 1,
      'totalDuration': durationInMilliseconds,
      'day': Timestamp.fromDateTime(startedAtUtc),
    };

    final exception = Exception('test');
    final expectedCreatedTask = {
      'code': 'build_days_created',
      'data': build,
      'context': exception.toString(),
      'createdAt': Timestamp.fromDateTime(startedAtUtc),
    };

    final firestoreMock = FirestoreMock();
    final collectionReferenceMock = CollectionReferenceMock();
    final documentReferenceMock = DocumentReferenceMock();
    final documentSnapshotMock = DocumentSnapshotMock();

    PostExpectation<Firestore> whenFirestore() {
      return when(documentSnapshotMock.firestore);
    }

    PostExpectation<CollectionReference> whenCollection(String withName) {
      whenFirestore().thenReturn(firestoreMock);

      return when(firestoreMock.collection(withName));
    }

    PostExpectation<DocumentReference> whenDocument({
      String withCollectionName,
    }) {
      whenCollection(withCollectionName).thenReturn(collectionReferenceMock);

      return when(collectionReferenceMock.document(any));
    }

    PostExpectation<Future<void>> whenSetDocumentData({
      String withCollectionName,
    }) {
      whenDocument(
        withCollectionName: withCollectionName,
      ).thenReturn(documentReferenceMock);

      return when(documentReferenceMock.setData(any, any));
    }

    PostExpectation whenSnapshotData() {
      return when(documentSnapshotMock.data);
    }

    tearDown(() {
      reset(documentSnapshotMock);
      reset(firestoreMock);
      reset(collectionReferenceMock);
      reset(documentReferenceMock);
    });

    test(
      "does not increment the total duration if the build document snapshot's duration is null",
      () async {
        whenDocument(withCollectionName: buildDaysCollectionName)
            .thenReturn(documentReferenceMock);

        final Map<String, dynamic> buildWithoutDuration = Map.from(build);
        buildWithoutDuration.remove('duration');

        whenSnapshotData()
            .thenReturn(DocumentData.fromMap(buildWithoutDuration));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentDataMatcher = predicate<DocumentData>((data) {
          return data.getNestedData('totalDuration').getInt('operand') == 0;
        });

        verify(
          documentReferenceMock.setData(argThat(documentDataMatcher), any),
        ).called(1);
      },
    );

    test(
      "uses a composite document id for the build days collection",
      () async {
        whenDocument(withCollectionName: buildDaysCollectionName)
            .thenReturn(documentReferenceMock);
        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentId =
            '${projectId}_${startedAtUtc.millisecondsSinceEpoch}';

        verify(collectionReferenceMock.document(documentId)).called(1);
      },
    );

    test(
      "creates a build days document from the build document snapshot's data",
      () async {
        whenDocument(withCollectionName: buildDaysCollectionName)
            .thenReturn(documentReferenceMock);
        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentDataMatcher = predicate<DocumentData>((data) {
          final count =
              data.getNestedData(buildDayStatusFieldName).getInt('operand');
          final totalDuration =
              data.getNestedData('totalDuration').getInt('operand');

          final projectIdsAreEqual =
              data.getString('projectId') == expectedBuildDayData['projectId'];
          final countsAreEqual =
              count == expectedBuildDayData[buildDayStatusFieldName];
          final totalDurationAreEqual =
              totalDuration == expectedBuildDayData['totalDuration'];
          final daysAreEqual =
              data.getTimestamp('day') == expectedBuildDayData['day'];

          return projectIdsAreEqual &&
              countsAreEqual &&
              totalDurationAreEqual &&
              daysAreEqual;
        });

        verify(
          documentReferenceMock.setData(argThat(documentDataMatcher), any),
        ).called(1);
      },
    );

    test(
      "does not create a task document if the build day data set successfully",
      () async {
        whenDocument(withCollectionName: buildDaysCollectionName)
            .thenReturn(documentReferenceMock);
        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(documentSnapshotMock, null);

        verifyNever(firestoreMock.collection(tasksCollectionName));
      },
    );

    test(
      "creates a task document if setting the build day's document data fails",
      () async {
        final _taskCollectionReferenceMock = CollectionReferenceMock();

        whenSetDocumentData(withCollectionName: buildDaysCollectionName)
            .thenAnswer((_) => Future.error(Exception('test')));

        when(firestoreMock.collection(tasksCollectionName))
            .thenReturn(_taskCollectionReferenceMock);
        when(_taskCollectionReferenceMock.add(any))
            .thenAnswer((_) => Future.value());

        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentDataMatcher = predicate<DocumentData>((data) {
          final codesAreEqual =
              data.getString('code') == expectedCreatedTask['code'];
          final dataAreEqual = MapEquality().equals(
            data.getNestedData('data').toMap(),
            expectedCreatedTask['data'],
          );
          final contextsAreEqual =
              data.getString('context') == expectedCreatedTask['context'];
          final daysAreEqual = data.getTimestamp('createdAt') ==
              expectedCreatedTask['createdAt'];

          return codesAreEqual &&
              dataAreEqual &&
              contextsAreEqual &&
              daysAreEqual;
        });

        verify(_taskCollectionReferenceMock.add(argThat(documentDataMatcher)))
            .called(1);
      },
    );
  });
}

//// Returns a [DateTime] representing the date in the UTC timezone created
/// from the given [dateTime].
DateTime _getUtcDate(DateTime dateTime) => dateTime.toUtc().date;

class FirestoreMock extends Mock implements Firestore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}
