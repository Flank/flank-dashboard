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
  const buildId = 'projectId_1';

  final startedAt = DateTime.now();
  final startedAtDayUtc = startedAt.toUtc().date;
  final testDataGenerator = BuildTestDataGenerator(
    projectId: projectId,
  );
  final buildJson = testDataGenerator.generateBuildJson();
  final buildDocumentData = DocumentData.fromMap(buildJson);

  final firestore = FirestoreMock();
  final collectionReference = CollectionReferenceMock();
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
    const eventContextParams = {'buildId': buildId};
    final eventContext = EventContextMock();

    PostExpectation<Map<String, String>> whenEventContextParam() {
      return when(eventContext.params);
    }

    tearDown(() {
      reset(eventContext);
    });

    test(
      "does not increment the successful builds duration if the build document snapshot's duration is null",
      () async {
        final buildJson = testDataGenerator.generateBuildJson(
          buildStatus: buildStatus,
          duration: null,
        );

        whenDocument().thenReturn(documentReference);
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(
          DocumentData.fromMap(buildJson),
        );

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, eventContext);

        verifyNever(firestore.collection(tasksCollectionName));
      },
    );

    test(
      "creates a task document with 'build_days_created' code if setting the build day's document data fails",
      () async {
        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocument().thenReturn(documentReference);
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, eventContext);

        final codeMatcher = predicate<DocumentData>(
          (data) => data.getString('code') == TaskCode.buildDaysCreated.value,
        );

        verify(collectionReference.add(argThat(codeMatcher))).called(1);
      },
    );

    test(
      "creates a task document with data equals to the build data if setting the build day's document data fails",
      () async {
        whenCreateTaskDocument().thenAnswer((_) => Future.value());
        whenDocument().thenReturn(documentReference);
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, eventContext);

        final dataMatcher = predicate<DocumentData>((data) {
          buildJson['startedAt'] = buildJson['startedAt'].toDateTime();
          buildJson.addAll({'id': buildId});

          return const MapEquality().equals(
            data.getNestedData('data').toMap(),
            buildJson,
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
        whenDocument().thenReturn(documentReference);
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await onBuildAddedHandler(documentSnapshot, eventContext);

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
        whenDocument().thenReturn(documentReference);
        whenEventContextParam().thenReturn(eventContextParams);
        when(documentSnapshot.data).thenReturn(buildDocumentData);

        await withClock(Clock.fixed(currentDateTime), () async {
          await onBuildAddedHandler(documentSnapshot, eventContext);

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
    final newDocumentSnapshot = DocumentSnapshotMock();
    final change = ChangeMock();
    final documentQuery = DocumentQueryMock();
    final querySnapshot = QuerySnapshotMock();
    final oldBuildJson = testDataGenerator.generateBuildJson(
      buildStatus: BuildStatus.inProgress,
      duration: null,
    );
    final oldBuildDocumentData = DocumentData.fromMap(oldBuildJson);

    PostExpectation<Future<QuerySnapshot>> whenGetTaskDocument() {
      whenFirestore().thenReturn(firestore);
      when(firestore.collection(tasksCollectionName))
          .thenReturn(collectionReference);
      when(collectionReference.where(
        any,
        isEqualTo: anyNamed('isEqualTo'),
      )).thenReturn(documentQuery);

      return when(documentQuery.get());
    }

    PostExpectation<List<DocumentSnapshot>> whenTaskDocuments() {
      whenGetTaskDocument().thenAnswer((_) => Future.value(querySnapshot));

      return when(querySnapshot.documents);
    }

    PostExpectation<DocumentData> whenAccessChangeData({
      DocumentSnapshot documentSnapshot,
      bool isAfter = true,
    }) {
      final PostExpectation whenChange =
          isAfter ? when(change.after) : when(change.before);

      whenChange.thenReturn(documentSnapshot);

      return when(documentSnapshot.data);
    }

    setUp(() {
      whenAccessChangeData(
        documentSnapshot: documentSnapshot,
        isAfter: false,
      ).thenReturn(oldBuildDocumentData);
      whenDocument().thenReturn(documentReference);
      whenTaskDocuments().thenReturn([]);
    });

    tearDown(() {
      reset(newDocumentSnapshot);
      reset(change);
      reset(documentQuery);
      reset(querySnapshot);
    });

    test(
      "uses a build id to get a task from the tasks collection",
      () async {
        final newBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: null,
        );

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));

        await onBuildUpdatedHandler(change, null);

        verify(collectionReference.where('data.id', isEqualTo: buildId))
            .called(1);
      },
    );

    test(
      "does not increment the successful builds duration if the updated build document snapshot's duration is null",
      () async {
        final newBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.successful,
          duration: null,
        );

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));

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
      "does not increment the successful builds duration if the updated build's status is not successful",
      () async {
        final newBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));

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
      "updates a build days document with project id equals to the build document snapshot's project id",
      () async {
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);

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
      "increments a build day document's successful field value if the updated build document snapshot's status is successful",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.successful.value;

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);

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
      "increments a build day document's failed field value if the updated build document snapshot's status is failed",
      () async {
        final buildDayStatusFieldName = BuildDayStatusFieldName.failed.value;
        final newBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.failed,
        );

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));

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
      "increments a build day document's unknown field value if the updated build document snapshot's status is unknown",
      () async {
        final buildDayStatusFieldName = BuildDayStatusFieldName.unknown.value;
        final newBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.unknown,
        );

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));

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
      "decrements a build day document's inProgress field value if the old build document snapshot's status is inProgress and there are no tasks with such build id in tasks collection",
      () async {
        final buildDayStatusFieldName =
            BuildDayStatusFieldName.inProgress.value;

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);

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
      "increments a build day document's successfulBuildsDuration field by the updated build document snapshot's duration if the updated build is successful",
      () async {
        final newBuildJson = testDataGenerator.generateBuildJson(
          duration: const Duration(milliseconds: durationInMilliseconds),
        );

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));

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
      "creates a build days document with day equals to the build document snapshot's startedAt UTC day",
      () async {
        final oldBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
          duration: null,
          startedAt: startedAt,
        );
        final expectedBuildDay = Timestamp.fromDateTime(startedAtDayUtc);

        whenAccessChangeData(
          documentSnapshot: documentSnapshot,
          isAfter: false,
        ).thenReturn(buildDocumentData);
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(oldBuildJson));

        await onBuildUpdatedHandler(change, null);

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
      "does not create a task document if the build day data updates successfully",
      () async {
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);

        await onBuildUpdatedHandler(change, null);

        verifyNever(collectionReference.add(any));
      },
    );

    test(
      "creates a task document with 'build_days_updated' code if updating the build day's document data fails",
      () async {
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        final codeMatcher = predicate<DocumentData>(
          (data) => data.getString('code') == TaskCode.buildDaysUpdated.value,
        );

        verify(collectionReference.add(argThat(codeMatcher))).called(1);
      },
    );

    test(
      "creates a task document with data equals to the old and new builds data if updating the build day's document data fails",
      () async {
        final oldBuildJson = testDataGenerator.generateBuildJson(
          buildStatus: BuildStatus.inProgress,
          duration: Duration.zero,
        );
        final newBuildJson = testDataGenerator.generateBuildJson();

        whenAccessChangeData(
          documentSnapshot: documentSnapshot,
          isAfter: false,
        ).thenReturn(DocumentData.fromMap(oldBuildJson));
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(DocumentData.fromMap(newBuildJson));
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        final dataMatcher = predicate<DocumentData>((data) {
          oldBuildJson['startedAt'] = oldBuildJson['startedAt'].toDateTime();
          newBuildJson['startedAt'] = newBuildJson['startedAt'].toDateTime();
          final expectedData = {
            'oldBuild': oldBuildJson,
            'newBuild': newBuildJson,
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

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);
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

        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);
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
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([documentSnapshot]);

        await onBuildUpdatedHandler(change, null);

        verify(documentReference.delete()).called(1);
      },
    );

    test(
      "does not delete an existing task if updating the build day's document data fails",
      () async {
        whenAccessChangeData(documentSnapshot: newDocumentSnapshot)
            .thenReturn(buildDocumentData);
        whenTaskDocuments().thenReturn([documentSnapshot]);
        whenCreateTaskDocument().thenAnswer((_) => Future.value());

        await onBuildUpdatedHandler(change, null);

        verifyNever(documentReference.delete());
      },
    );
  });
}

class FirestoreMock extends Mock implements Firestore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}

class EventContextMock extends Mock implements EventContext {}

class ChangeMock extends Mock implements Change<DocumentSnapshotMock> {}

class DocumentQueryMock extends Mock implements DocumentQuery {}

class QuerySnapshotMock extends Mock implements QuerySnapshot {}
