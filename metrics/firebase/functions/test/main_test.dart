// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:functions/main.dart';
import 'package:functions/models/build_day_status_field_name.dart';
import 'package:functions/models/task_code.dart';
import 'package:functions/models/task_data.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_utils/test_data/build_test_data_generator.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  const tasksCollectionName = 'tasks';
  const projectId = 'projectId';
  const buildNumber = 1;
  const durationInMilliseconds = 123;
  const buildStatus = BuildStatus.successful;

  final startedAt = DateTime.now();
  final startedAtDayUtc = startedAt.toUtc().date;
  final testDataGenerator = BuildTestDataGenerator(
    projectId: projectId,
  );
  final buildJson = testDataGenerator.generateBuildJson();
  final buildDocumentData = DocumentData.fromMap(buildJson);

  final firestore = _FirestoreMock();
  final collectionReference = _CollectionReferenceMock();
  final documentReference = _DocumentReferenceMock();
  final documentSnapshot = _DocumentSnapshotMock();

  Matcher documentFieldIncrementMatcher(String fieldName, int expectedCount) {
    return predicate<DocumentData>((data) {
      final count = data.getNestedData(fieldName).getInt('operand');

      return count == expectedCount;
    });
  }

  PostExpectation<DocumentReference> whenDocument() {
    when(documentSnapshot.firestore).thenReturn(firestore);

    return when(firestore.document(any));
  }

  PostExpectation<DocumentData> whenDocumentData() {
    whenDocument().thenReturn(documentReference);

    return when(documentSnapshot.data);
  }

  PostExpectation<Future<DocumentReference>> whenCreateTaskDocument({
    Exception exception,
  }) {
    when(documentReference.setData(any, any))
        .thenAnswer((_) => Future.error(exception));

    when(firestore.collection(tasksCollectionName))
        .thenReturn(collectionReference);

    return when(collectionReference.add(any));
  }

  tearDown(() {
    reset(documentSnapshot);
    reset(firestore);
    reset(collectionReference);
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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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
        whenDocumentData().thenReturn(buildDocumentData);

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

        whenDocumentData().thenReturn(buildDocumentData);

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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

        whenDocumentData().thenReturn(DocumentData.fromMap(buildJson));

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
        whenDocumentData().thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        verifyNever(firestore.collection(tasksCollectionName));
      },
    );

    test(
      "creates a task document with 'build_days_created' code if setting the build day's document data fails",
      () async {
        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocumentData().thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final codeMatcher = predicate<DocumentData>(
          (data) => data.getString('code') == TaskCode.buildDaysCreated.value,
        );

        verify(collectionReference.add(argThat(codeMatcher))).called(1);
      },
    );

    test(
      "creates a task document with data equals to the build data if setting the build day's document data fails",
      () async {
        final buildJson = testDataGenerator.generateBuildJson();
        final buildDocumentData = DocumentData.fromMap(buildJson);
        final expectedTaskDataJson =
            BuildDataDeserializer.fromJson(buildJson).toJson();

        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocumentData().thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final dataMatcher = predicate<DocumentData>((data) {
          return const MapEquality().equals(
            data.getNestedData('data').toMap(),
            expectedTaskDataJson,
          );
        });

        verify(collectionReference.add(argThat(dataMatcher))).called(1);
      },
    );

    test(
      "creates a task document with context equals to the error string representation if setting the build day's document data fails",
      () async {
        final exception = Exception('test');

        whenCreateTaskDocument(exception: exception)
            .thenAnswer((_) => Future.value());
        whenDocumentData().thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, null);

        final contextMatcher = predicate<DocumentData>(
          (data) => data.getString('context') == exception.toString(),
        );

        verify(
          collectionReference.add(
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
        whenDocumentData().thenReturn(buildDocumentData);

        await withClock(Clock.fixed(currentDateTime), () async {
          await onBuildAddedHandler(documentSnapshot, null);

          final createdAtMatcher = predicate<DocumentData>((data) {
            return data.getTimestamp('createdAt') == expectedCreatedAt;
          });

          verify(
            collectionReference.add(
              argThat(createdAtMatcher),
            ),
          ).called(1);
        });
      },
    );
  });

  group("onBuildUpdatedHandler", () {
    final beforeDocumentSnapshot = _DocumentSnapshotMock();
    final afterDocumentSnapshot = _DocumentSnapshotMock();
    final taskDocumentSnapshot = _DocumentSnapshotMock();
    final change = _ChangeMock();
    final documentQuery = _DocumentQueryMock();
    final querySnapshot = _QuerySnapshotMock();
    final beforeBuildJson = testDataGenerator.generateBuildJson(
      buildStatus: BuildStatus.inProgress,
      duration: null,
    );
    final beforeBuildDocumentData = DocumentData.fromMap(beforeBuildJson);
    final createdTaskData = TaskData(
      code: TaskCode.buildDaysCreated,
      createdAt: DateTime.now(),
    );
    final taskCreatedDocumentData = DocumentData.fromMap(
      createdTaskData.toMap(),
    );

    PostExpectation<Future<QuerySnapshot>> whenGetTaskDocuments() {
      when(afterDocumentSnapshot.firestore).thenReturn(firestore);
      when(firestore.collection(tasksCollectionName))
          .thenReturn(collectionReference);
      when(collectionReference.where(
        any,
        isEqualTo: anyNamed('isEqualTo'),
      )).thenReturn(documentQuery);
      when(documentQuery.where(
        any,
        isEqualTo: anyNamed('isEqualTo'),
      )).thenReturn(documentQuery);

      return when(documentQuery.get());
    }

    PostExpectation<List<DocumentSnapshot>> whenTaskDocuments() {
      whenGetTaskDocuments().thenAnswer((_) => Future.value(querySnapshot));

      return when(querySnapshot.documents);
    }

    PostExpectation<DocumentData> whenChangeBeforeData() {
      when(change.before).thenReturn(beforeDocumentSnapshot);

      return when(beforeDocumentSnapshot.data);
    }

    PostExpectation<DocumentData> whenChangeAfterData() {
      when(change.after).thenReturn(afterDocumentSnapshot);

      return when(afterDocumentSnapshot.data);
    }

    tearDown(() {
      reset(beforeDocumentSnapshot);
      reset(afterDocumentSnapshot);
      reset(taskDocumentSnapshot);
      reset(change);
      reset(documentQuery);
      reset(querySnapshot);
    });

    test(
      "does not update a build day document's if build's status does not change",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
        );
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));

        await onBuildUpdatedHandler(change, null);

        verifyNever(documentReference.setData(any, any));
      },
    );

    test(
      "gets the task with the data's project id equals to the updated build's build number",
      () async {
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: null,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        verify(
          collectionReference.where(
            'data.projectId',
            isEqualTo: projectId,
          ),
        ).called(1);
      },
    );

    test(
      "gets the task with the data's build number equals to the updated build's build number",
      () async {
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          buildNumber: buildNumber,
          duration: null,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        verify(
          documentQuery.where(
            'data.buildNumber',
            isEqualTo: buildNumber,
          ),
        ).called(1);
      },
    );

    test(
      "gets the task with the buildDaysCreated code",
      () async {
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          buildNumber: buildNumber,
          duration: null,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        verify(
          documentQuery.where(
            'code',
            isEqualTo: TaskCode.buildDaysCreated.value,
          ),
        ).called(1);
      },
    );

    test(
      "does not increment the successful builds duration if the build document snapshot's duration updated to null",
      () async {
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: null,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "does not increment the successful builds duration if the build status updated to not successful one",
      () async {
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "updates a build days document with project id equals to the changed build's project id",
      () async {
        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "increments a build day document's successful field value if the build status updated to successful",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.successful.value;

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "increments a build day document's failed field value if the build status updated to failed",
      () async {
        final buildDayStatusFieldName = BuildDayStatusFieldName.failed.value;
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.failed,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "increments a build day document's unknown field value if the build status updated to unknown",
      () async {
        final buildDayStatusFieldName = BuildDayStatusFieldName.unknown.value;
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "increments a build day document's inProgress field value if the build status updated to inProgress",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.inProgress.value;
        final beforeBuildJson = testDataGenerator.generateBuildJson();
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(DocumentData.fromMap(
          beforeBuildJson,
        ));
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "decrements a build day document's inProgress field value if the before build document snapshot's status is inProgress and there are no tasks with such build id in tasks collection",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.inProgress.value;

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, -1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "decrements a build day document's unknown field value if the before build document snapshot's status is unknown and there are no tasks with such build id in tasks collection",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );
        final buildDayStatusFieldName = BuildDayStatusFieldName.unknown.value;

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, -1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "decrements a build day document's failed field value if the before build document snapshot's status is failed and there are no tasks with such build id in tasks collection",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.failed,
        );
        final buildDayStatusFieldName = BuildDayStatusFieldName.failed.value;

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, -1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "decrements a build day document's successful field value if the before build document snapshot's status is successful and there are no tasks with such build id in tasks collection",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.successful.value;
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
        );
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final statusFieldIncrementMatcher =
            documentFieldIncrementMatcher(buildDayStatusFieldName, -1);

        verify(
          documentReference.setData(
            argThat(statusFieldIncrementMatcher),
            any,
          ),
        ).called(1);
      },
    );

    test(
      "increments a build day document's successfulBuildsDuration field value by the changed build's duration if the build status updated to successful",
      () async {
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: const Duration(milliseconds: durationInMilliseconds),
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

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
      "decrements a build day document's successfulBuildsDuration field value by the before build document snapshot's duration if the build status updated from successful to failed",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: const Duration(milliseconds: durationInMilliseconds),
        );
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.failed,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final successfulDurationIncrementMatcher =
            documentFieldIncrementMatcher(
          'successfulBuildsDuration',
          -durationInMilliseconds,
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
      "decrements a build day document's successfulBuildsDuration field value by the before build document snapshot's duration if the build status updated from successful to unknown",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: const Duration(milliseconds: durationInMilliseconds),
        );
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final successfulDurationIncrementMatcher =
            documentFieldIncrementMatcher(
          'successfulBuildsDuration',
          -durationInMilliseconds,
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
      "decrements a build day document's successfulBuildsDuration field value by the before build document snapshot's duration if the build status updated from successful to inProgress",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: const Duration(milliseconds: durationInMilliseconds),
        );
        final afterBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
        );

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final successfulDurationIncrementMatcher =
            documentFieldIncrementMatcher(
          'successfulBuildsDuration',
          -durationInMilliseconds,
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
      "updates a build days document with day equals to the build document snapshot's startedAt UTC day",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
          duration: null,
          startedAt: startedAt,
        );
        final expectedBuildDay = Timestamp.fromDateTime(startedAtDayUtc);

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        final dayMatcher = predicate<DocumentData>((data) {
          return data.getTimestamp('day') == expectedBuildDay;
        });

        verify(documentReference.setData(argThat(dayMatcher), any)).called(1);
      },
    );

    test(
      "does not create a task document if the build day data updates successfully",
      () async {
        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        verifyNever(collectionReference.add(any));
      },
    );

    test(
      "creates a task document with 'build_days_updated' code if updating the build day's document data fails",
      () async {
        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        final codeMatcher = predicate<DocumentData>(
          (data) => data.getString('code') == TaskCode.buildDaysUpdated.value,
        );

        verify(collectionReference.add(argThat(codeMatcher))).called(1);
      },
    );

    test(
      "creates a task document with data equals to the before and after builds data if updating the build day's document data fails",
      () async {
        final beforeBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
          duration: Duration.zero,
        );
        final afterBuildJson = testDataGenerator.generateBuildJson();
        final expectedBeforeTaskDataJson =
            BuildDataDeserializer.fromJson(beforeBuildJson).toJson();
        final expectedAfterTaskDataJson =
            BuildDataDeserializer.fromJson(afterBuildJson).toJson();

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(
          DocumentData.fromMap(beforeBuildJson),
        );
        whenChangeAfterData().thenReturn(DocumentData.fromMap(afterBuildJson));
        whenTaskDocuments().thenReturn([]);
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        final dataMatcher = predicate<DocumentData>((data) {
          final expectedData = {
            'before': expectedBeforeTaskDataJson,
            'after': expectedAfterTaskDataJson,
          };

          return const DeepCollectionEquality().equals(
            data.getNestedData('data').toMap(),
            expectedData,
          );
        });

        verify(collectionReference.add(argThat(dataMatcher))).called(1);
      },
    );

    test(
      "creates a task document with context equals to the error string representation if updating the build day's document data fails",
      () async {
        final exception = Exception('test');

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);
        whenCreateTaskDocument(exception: exception)
            .thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        final contextMatcher = predicate<DocumentData>(
          (data) => data.getString('context') == exception.toString(),
        );

        verify(collectionReference.add(argThat(contextMatcher))).called(1);
      },
    );

    test(
      "creates a task document with createdAt equals to the current date time if updating the build day's document data fails",
      () async {
        final currentDateTime = DateTime.now();
        final expectedCreatedAt = Timestamp.fromDateTime(currentDateTime);

        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await withClock(Clock.fixed(currentDateTime), () async {
          await onBuildUpdatedHandler(change, null);

          final createdAtMatcher = predicate<DocumentData>((data) {
            return data.getTimestamp('createdAt') == expectedCreatedAt;
          });

          verify(collectionReference.add(argThat(createdAtMatcher))).called(1);
        });
      },
    );

    test(
      "deletes an existing task if the build day data updates successfully",
      () async {
        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([taskDocumentSnapshot]);
        when(taskDocumentSnapshot.data).thenReturn(taskCreatedDocumentData);

        await onBuildUpdatedHandler(change, null);

        verify(documentReference.delete()).called(1);
      },
    );

    test(
      "does not delete an existing task if updating the build day's document data fails",
      () async {
        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([taskDocumentSnapshot]);
        when(taskDocumentSnapshot.data).thenReturn(taskCreatedDocumentData);
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        verifyNever(documentReference.delete());
      },
    );

    test(
      "does not delete any task if the task does not exist",
      () async {
        whenDocument().thenReturn(documentReference);
        whenChangeBeforeData().thenReturn(beforeBuildDocumentData);
        whenChangeAfterData().thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([]);

        await onBuildUpdatedHandler(change, null);

        verifyNever(documentReference.delete());
      },
    );
  });
}

class _FirestoreMock extends Mock implements Firestore {}

class _CollectionReferenceMock extends Mock implements CollectionReference {}

class _DocumentReferenceMock extends Mock implements DocumentReference {}

class _DocumentSnapshotMock extends Mock implements DocumentSnapshot {}

class _ChangeMock extends Mock implements Change<_DocumentSnapshotMock> {}

class _DocumentQueryMock extends Mock implements DocumentQuery {}

class _QuerySnapshotMock extends Mock implements QuerySnapshot {}
