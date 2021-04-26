// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../lib/main.dart';

void main() {
  group(("onBuildAddedHandler"), () {
    const buildDaysCollectionName = 'build_days';
    const tasksCollectionName = 'tasks';
    const projectId = 'projectId';
    const durationInMilliseconds = 123;
    final buildStartedAt = Timestamp.fromDateTime(DateTime.now());
    final dateInUTC = _getDateInUTC(buildStartedAt);

    final build = {
      'duration': durationInMilliseconds,
      'projectId': projectId,
      'buildStatus': 'BuildStatus.successful',
      'startedAt': buildStartedAt,
      'coverage': 100,
      'url': 'url',
      'workflowName': 'workflowName',
    };

    final expectedBuildDayData = {
      'projectId': projectId,
      'successful': 1,
      'totalDuration': durationInMilliseconds,
      'day': Timestamp.fromDateTime(dateInUTC)
    };

    final exception = Exception('test');
    final expectedCreatedTask = {
      'code': 'build_days_created',
      'data': build,
      'context': exception.toString(),
      'createdAt': buildStartedAt,
    };

    final _firestoreMock = FirestoreMock();
    final _collectionReferenceMock = CollectionReferenceMock();
    final _documentReferenceMock = DocumentReferenceMock();
    final _documentSnapshotMock = DocumentSnapshotMock();
    final _eventContextMock = EventContextMock();

    tearDown(() {
      reset(_documentSnapshotMock);
      reset(_eventContextMock);
      reset(_firestoreMock);
      reset(_collectionReferenceMock);
      reset(_documentReferenceMock);
    });

    PostExpectation<Firestore> whenFirestore() {
      return when(_documentSnapshotMock.firestore);
    }

    PostExpectation<CollectionReference> whenCollection(String withName) {
      whenFirestore().thenReturn(_firestoreMock);

      return when(_firestoreMock.collection(withName));
    }

    PostExpectation<DocumentReference> whenDocument({
      String withCollectionName,
    }) {
      whenCollection(withCollectionName).thenReturn(_collectionReferenceMock);

      return when(_collectionReferenceMock.document(any));
    }

    PostExpectation<Future<void>> whenDocumentData({
      String withCollectionName,
    }) {
      whenDocument(
        withCollectionName: withCollectionName,
      ).thenReturn(_documentReferenceMock);

      return when(_documentReferenceMock.setData(any, any));
    }

    PostExpectation whenSnapshotData() {
      return when(_documentSnapshotMock.data);
    }

    test(
      "sets a build day document with the 0 duration if the build document snapshot's duration is a null",
      () async {
        whenDocumentData(withCollectionName: buildDaysCollectionName)
            .thenAnswer((_) => Future.value());

        final Map<String, dynamic> buildWithoutDuration = Map.from(build);
        buildWithoutDuration.remove('duration');

        whenSnapshotData()
            .thenReturn(DocumentData.fromMap(buildWithoutDuration));

        await onBuildAddedHandler(_documentSnapshotMock, _eventContextMock);

        final documentDataMatcher = predicate<DocumentData>((data) {
          return data.getNestedData('totalDuration').getInt('operand') == 0;
        });

        final optionMatcher = predicate<SetOptions>((option) => option.merge);

        verify(
          _documentReferenceMock.setData(
            argThat(documentDataMatcher),
            argThat(optionMatcher),
          ),
        ).called(1);
      },
    );

    test(
      "uses a composite document id for build days collection",
      () async {
        whenDocument(withCollectionName: buildDaysCollectionName)
            .thenReturn(_documentReferenceMock);
        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(_documentSnapshotMock, _eventContextMock);

        final documentId = '${projectId}_${dateInUTC.millisecondsSinceEpoch}';

        verify(_collectionReferenceMock.document(documentId)).called(1);
      },
    );

    test(
      "creates a build days document from the build document snapshot's data",
      () async {
        whenDocumentData(withCollectionName: buildDaysCollectionName)
            .thenAnswer((_) => Future.value());
        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(_documentSnapshotMock, _eventContextMock);

        final documentDataMatcher = predicate<DocumentData>((data) {
          final count = data.getNestedData('successful').getInt('operand');
          final totalDuration =
              data.getNestedData('totalDuration').getInt('operand');

          final projectIdsAreEqual =
              data.getString('projectId') == expectedBuildDayData['projectId'];
          final countsAreEqual = count == expectedBuildDayData['successful'];
          final totalDurationAreEqual =
              totalDuration == expectedBuildDayData['totalDuration'];
          final daysAreEqual =
              data.getTimestamp('day') == expectedBuildDayData['day'];

          return projectIdsAreEqual &&
              countsAreEqual &&
              totalDurationAreEqual &&
              daysAreEqual;
        });

        final optionMatcher = predicate<SetOptions>((option) => option.merge);

        verify(
          _documentReferenceMock.setData(
            argThat(documentDataMatcher),
            argThat(optionMatcher),
          ),
        ).called(1);
      },
    );

    test("does not create task document after created a build day", () async {
      whenDocumentData(withCollectionName: buildDaysCollectionName)
          .thenAnswer((_) => Future.value());
      whenSnapshotData().thenReturn(DocumentData.fromMap(build));

      await onBuildAddedHandler(_documentSnapshotMock, _eventContextMock);

      verifyNever(_firestoreMock.collection(tasksCollectionName));
    });

    test(
      "creates a task document if setting build day's document data fails",
      () async {
        final _taskCollectionReferenceMock = CollectionReferenceMock();

        whenDocumentData(withCollectionName: buildDaysCollectionName)
            .thenAnswer((_) => Future.error(Exception('test')));

        when(_firestoreMock.collection(tasksCollectionName))
            .thenReturn(_taskCollectionReferenceMock);
        when(_taskCollectionReferenceMock.add(any))
            .thenAnswer((_) => Future.value());

        whenSnapshotData().thenReturn(DocumentData.fromMap(build));

        await onBuildAddedHandler(_documentSnapshotMock, _eventContextMock);

        final documentDataMatcher = predicate<DocumentData>((data) {
          final codesAreEqual =
              data.getString('code') == expectedCreatedTask['code'];
          final dataAreEqual = MapEquality().equals(
            data.getNestedData('data').toMap(),
            expectedCreatedTask['data'],
          );
          final contextsAreEqual =
              data.getString('context') == expectedCreatedTask['context'];
          final daysAreEqual =
              data.getTimestamp('day') == expectedCreatedTask['day'];

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

/// Returns a [DateTime] in UTC from the given [timestamp].
DateTime _getDateInUTC(Timestamp timestamp) {
  final dateTime = timestamp.toDateTime().toUtc();

  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
}

class FirestoreMock extends Mock implements Firestore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}

class EventContextMock extends Mock implements EventContext {}
