// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/main.dart';
import 'package:functions/models/build_day_status_field_name.dart';
import 'package:functions/models/task_code.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_utils/test_data/build_test_data_generator.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  const tasksCollectionName = 'tasks';
  const projectId = 'projectId';
  const durationInMilliseconds = 123;
  const buildStatus = BuildStatus.successful;

  final startedAt = DateTime.now();
  final startedAtDayUtc = startedAt.toUtc().date;
  final testDataGenerator = BuildTestDataGenerator(
    projectId: projectId,
  );
  final buildJson = testDataGenerator.generateBuildJson();
  final buildDocumentData = DocumentData.fromMap(buildJson);

  final firestore = FirestoreMock();
  final collectionReference = CollectionReferenceMock();
  final taskCollectionReference = CollectionReferenceMock();
  final documentReference = DocumentReferenceMock();
  final documentSnapshot = DocumentSnapshotMock();

  Matcher documentFieldIncrementMatcher(String fieldName, int expectedCount) {
    return predicate<DocumentData>((data) {
      final count = data.getNestedData(fieldName).getInt('operand');

      return count == expectedCount;
    });
  }

  PostExpectation<Firestore> whenFirestore() {
    return when(documentSnapshot.firestore);
  }

  PostExpectation<DocumentReference> whenDocument() {
    whenFirestore().thenReturn(firestore);

    return when(firestore.document(any));
  }

  PostExpectation<Future<void>> whenSetDocumentData() {
    whenDocument().thenReturn(documentReference);

    return when(documentReference.setData(any, any));
  }

  PostExpectation<Future<DocumentReference>> whenCreateTaskDocument({
    Exception exception,
  }) {
    whenSetDocumentData().thenAnswer((_) => Future.error(exception));

    when(firestore.collection(tasksCollectionName))
        .thenReturn(taskCollectionReference);

    return when(taskCollectionReference.add(any));
  }

  tearDown(() {
    reset(documentSnapshot);
    reset(firestore);
    reset(collectionReference);
    reset(taskCollectionReference);
    reset(documentReference);
  });

  group("onBuildAddedHandler", () {
    test(
      "does not increment the successful builds duration if the build document snapshot's duration is null",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: buildStatus,
          duration: null,
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final successfulDurationIncrementMatcher =
            documentFieldIncrementMatcher('successfulBuildsDuration', 0);

        verify(
          documentReference.setData(
            argThat(successfulDurationIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "does not increment the successful builds duration if the build's status is not successful",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final successfulDurationIncrementMatcher =
            documentFieldIncrementMatcher('successfulBuildsDuration', 0);

        verify(
          documentReference.setData(
            argThat(successfulDurationIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "uses a composite document id for the build days collection",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: startedAt,
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final documentId =
            '${projectId}_${startedAtDayUtc.millisecondsSinceEpoch}';

        verify(firestore.document('build_days/$documentId')).called(1);
      },
    );

    test(
      "trims the time part of the build's started at parameter and converts it to UTC",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: startedAt,
        );
        final expectedDate = startedAtDayUtc.millisecondsSinceEpoch;

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        expect(
          verify(firestore.document(captureAny)).captured.single,
          contains(expectedDate.toString()),
        );
      },
    );

    test(
      "creates a build days document with project id equals to the build document snapshot's project id",
      () async {
        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final projectIdMatcher = predicate<DocumentData>(
          (data) => data.getString('projectId') == projectId,
        );

        verify(
          documentReference.setData(
            argThat(projectIdMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's successful field value if the build document snapshot's status is successful",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.successful.value;

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, 1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's failed field value if the build document snapshot's status is failed",
      () async {
        final buildDayStatusFieldName = BuildDayStatusFieldName.failed.value;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.failed,
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, 1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's unknown field value if the build document snapshot's status is unknown",
      () async {
        final buildDayStatusFieldName = BuildDayStatusFieldName.unknown.value;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, 1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's inProgress field value if the build document snapshot's status is inProgress",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.inProgress.value;
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, 1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's successfulBuildsDuration field by the build document snapshot's duration if the build is successful",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          duration: const Duration(milliseconds: durationInMilliseconds),
        );

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final successfulDurationIncrementMatcher =
            documentFieldIncrementMatcher(
          'successfulBuildsDuration',
          durationInMilliseconds,
        );

        verify(
          documentReference.setData(
            argThat(successfulDurationIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "creates a build days document with day equals to the build document snapshot's startedAt UTC day",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          startedAt: startedAt,
        );
        final expectedBuildDay = Timestamp.fromDateTime(startedAtDayUtc);

        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, null);

        final dayMatcher = predicate<DocumentData>((data) {
          return data.getTimestamp('day') == expectedBuildDay;
        });

        verify(
          documentReference.setData(
            argThat(dayMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "does not create a task document if the build day data set successfully",
      () async {
        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        verifyNever(firestore.collection(tasksCollectionName));
      },
    );

    test(
      "creates a task document with 'build_days_created' code if setting the build day's document data fails",
      () async {
        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final codeMatcher = predicate<DocumentData>(
          (data) => data.getString('code') == TaskCode.buildDaysCreated.value,
        );

        verify(taskCollectionReference.add(argThat(codeMatcher))).called(1);
      },
    );

    test(
      "creates a task document with data equals to the build data if setting the build day's document data fails",
      () async {
        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final dataMatcher = predicate<DocumentData>((data) {
          return const MapEquality().equals(
            data.getNestedData('data').toMap(),
            buildJson,
          );
        });

        verify(taskCollectionReference.add(argThat(dataMatcher))).called(1);
      },
    );

    test(
      "creates a task document with context equals to the error string representation if setting the build day's document data fails",
      () async {
        final exception = Exception('test');

        whenCreateTaskDocument(exception: exception)
            .thenAnswer((_) => Future.value());
        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final contextMatcher = predicate<DocumentData>(
          (data) => data.getString('context') == exception.toString(),
        );

        verify(
          taskCollectionReference.add(
            argThat(contextMatcher),
          ),
        ).called(1);
      },
    );

    test(
      "creates a task document with createdAt equals to the current date time if setting the build day's document data fails",
      () async {
        final currentDateTime = DateTime.now();
        final expectedCreatedAt = Timestamp.fromDateTime(currentDateTime);

        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocument().thenReturn(documentReference);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await withClock(Clock.fixed(currentDateTime), () async {
          await onBuildAddedHandler(documentSnapshot, null);

          final createdAtMatcher = predicate<DocumentData>((data) {
            return data.getTimestamp('createdAt') == expectedCreatedAt;
          });

          verify(
            taskCollectionReference.add(
              argThat(createdAtMatcher),
            ),
          ).called(1);
        });
      },
    );
  });
}

class FirestoreMock extends Mock implements Firestore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}
