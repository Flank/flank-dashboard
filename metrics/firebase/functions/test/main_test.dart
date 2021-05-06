// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/task_code.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../lib/main.dart';
import 'test_utils/test_data/build_test_data_generator.dart';

void main() {
  group(("onBuildAddedHandler"), () {
    const tasksCollectionName = 'tasks';
    const projectId = 'projectId';
    const durationInMilliseconds = 123;
    final startedAt = DateTime.now();
    final startedAtDayUtc = startedAt.toUtc().date;
    final buildStatus = BuildStatus.successful;

    final testDataGenerator = BuildTestDataGenerator(
      projectId: projectId,
    );

    final firestoreMock = FirestoreMock();
    final collectionReferenceMock = CollectionReferenceMock();
    final taskCollectionReferenceMock = CollectionReferenceMock();
    final documentReferenceMock = DocumentReferenceMock();
    final documentSnapshotMock = DocumentSnapshotMock();

    PostExpectation<Firestore> whenFirestore() {
      return when(documentSnapshotMock.firestore);
    }

    PostExpectation<DocumentReference> whenDocument() {
      whenFirestore().thenReturn(firestoreMock);

      return when(firestoreMock.document(any));
    }

    PostExpectation<Future<void>> whenSetDocumentData() {
      whenDocument().thenReturn(documentReferenceMock);

      return when(documentReferenceMock.setData(any, any));
    }

    PostExpectation<DocumentData> whenDocumentSnapshotData() {
      whenDocument().thenReturn(documentReferenceMock);

      return when(documentSnapshotMock.data);
    }

    PostExpectation<Future<DocumentReference>> whenCreateTaskDocument() {
      whenSetDocumentData().thenAnswer((_) => Future.error(Exception('test')));

      when(firestoreMock.collection(tasksCollectionName))
          .thenReturn(taskCollectionReferenceMock);

      return when(taskCollectionReferenceMock.add(any));
    }

    tearDown(() {
      reset(documentSnapshotMock);
      reset(firestoreMock);
      reset(collectionReferenceMock);
      reset(taskCollectionReferenceMock);
      reset(documentReferenceMock);
    });

    test(
      "does not increment the successful builds duration if the build document snapshot's duration is null",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: buildStatus,
          duration: null,
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentDataMatcher = predicate<DocumentData>((data) {
          final operand =
              data.getNestedData('successfulBuildsDuration').getInt('operand');

          return operand == 0;
        });

        verify(
          documentReferenceMock.setData(argThat(documentDataMatcher), any),
        ).called(1);
      },
    );

    test(
      "does not increment the successful builds duration if the build's status is not successful",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentDataMatcher = predicate<DocumentData>((data) {
          final operand =
              data.getNestedData('successfulBuildsDuration').getInt('operand');
          return operand == 0;
        });

        verify(
          documentReferenceMock.setData(argThat(documentDataMatcher), any),
        ).called(1);
      },
    );

    test(
      "uses a composite document id for the build days collection",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: startedAt,
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final documentId =
            '${projectId}_${startedAtDayUtc.millisecondsSinceEpoch}';

        verify(firestoreMock.document('build_days/$documentId')).called(1);
      },
    );

    test(
      "trims the time part of the build's started at parameter and converts it to UTC",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: startedAt,
        );
        final expectedDate = startedAtDayUtc.millisecondsSinceEpoch;

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        expect(
          verify(firestoreMock.document(captureAny)).captured.single,
          contains(expectedDate.toString()),
        );
      },
    );

    test(
      "creates a build days document with project id equals to the build document snapshot's project id",
      () async {
        final buildJson = testDataGenerator.generateBuildJson();

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final projectIdMatcher = predicate<DocumentData>(
          (data) => data.getString('projectId') == projectId,
        );

        verify(
          documentReferenceMock.setData(
            argThat(projectIdMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's successful field value if the build document snapshot's status is successful",
      () async {
        const buildDayStatusFieldName = 'successful';
        final buildJson = testDataGenerator.generateBuildJson();

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final countMatcher = predicate<DocumentData>((data) {
          final count =
              data.getNestedData(buildDayStatusFieldName).getInt('operand');

          return count == 1;
        });

        verify(
          documentReferenceMock.setData(
            argThat(countMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's failed field value if the build document snapshot's status is failed",
      () async {
        const buildDayStatusFieldName = 'failed';
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.failed,
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final countMatcher = predicate<DocumentData>((data) {
          final count =
              data.getNestedData(buildDayStatusFieldName).getInt('operand');

          return count == 1;
        });

        verify(
          documentReferenceMock.setData(
            argThat(countMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's unknown field value if the build document snapshot's status is unknown",
      () async {
        const buildDayStatusFieldName = 'unknown';
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final countMatcher = predicate<DocumentData>((data) {
          final count =
              data.getNestedData(buildDayStatusFieldName).getInt('operand');

          return count == 1;
        });

        verify(
          documentReferenceMock.setData(
            argThat(countMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's inProgress field value if the build document snapshot's status is inProgress",
      () async {
        const buildDayStatusFieldName = 'inProgress';
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final countMatcher = predicate<DocumentData>((data) {
          final count =
              data.getNestedData(buildDayStatusFieldName).getInt('operand');

          return count == 1;
        });

        verify(
          documentReferenceMock.setData(
            argThat(countMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's successfulBuildsDuration field by the build document snapshot's duration if the build is successful",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          duration: Duration(milliseconds: durationInMilliseconds),
        );

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final durationMatcher = predicate<DocumentData>((data) {
          final duration =
              data.getNestedData('successfulBuildsDuration').getInt('operand');

          return duration == durationInMilliseconds;
        });

        verify(
          documentReferenceMock.setData(
            argThat(durationMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "creates a build days document with day equals to the build document snapshot's day",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: startedAt,
        );
        final expectedBuildDay = Timestamp.fromDateTime(startedAtDayUtc);

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final dayMatcher = predicate<DocumentData>((data) {
          return data.getTimestamp('day') == expectedBuildDay;
        });

        verify(
          documentReferenceMock.setData(
            argThat(dayMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "does not create a task document if the build day data set successfully",
      () async {
        final buildJson = testDataGenerator.generateBuildJson();

        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        verifyNever(firestoreMock.collection(tasksCollectionName));
      },
    );

    test(
      "creates a task document with 'build_days_created' code if setting the build day's document data fails",
      () async {
        final buildJson = testDataGenerator.generateBuildJson();

        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final codeMatcher = predicate<DocumentData>(
          (data) => data.getString('code') == TaskCode.buildDaysCreated.value,
        );

        verify(taskCollectionReferenceMock.add(argThat(codeMatcher))).called(1);
      },
    );

    test(
      "creates a task document with data equals to the build data if setting the build day's document data fails",
      () async {
        final buildJson = testDataGenerator.generateBuildJson();

        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final dataMatcher = predicate<DocumentData>((data) {
          return MapEquality().equals(
            data.getNestedData('data').toMap(),
            buildJson,
          );
        });

        verify(taskCollectionReferenceMock.add(argThat(dataMatcher))).called(1);
      },
    );

    test(
      "creates a task document with context equals to the error string representation if setting the build day's document data fails",
      () async {
        final exception = Exception('test');
        final buildJson = testDataGenerator.generateBuildJson();

        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await onBuildAddedHandler(documentSnapshotMock, null);

        final contextMatcher = predicate<DocumentData>(
          (data) => data.getString('context') == exception.toString(),
        );

        verify(taskCollectionReferenceMock.add(
          argThat(contextMatcher),
        )).called(1);
      },
    );

    test(
      "creates a task document with created at equals to the current date time if setting the build day's document data fails",
      () async {
        final buildJson = testDataGenerator.generateBuildJson();
        final expectedStartedAt = Timestamp.fromDateTime(startedAt);

        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocumentSnapshotData().thenReturn(DocumentData.fromMap(buildJson));

        await withClock(Clock.fixed(startedAt), () async {
          await onBuildAddedHandler(documentSnapshotMock, null);

          final createdAtMatcher = predicate<DocumentData>((data) {
            return data.getTimestamp('createdAt') == expectedStartedAt;
          });

          verify(taskCollectionReferenceMock.add(
            argThat(createdAtMatcher),
          )).called(1);
        });
      },
    );
  });
}

class FirestoreMock extends Mock implements Firestore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}
