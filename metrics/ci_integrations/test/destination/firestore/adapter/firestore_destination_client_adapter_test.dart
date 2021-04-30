// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/error/destination_error.dart';
import 'package:ci_integration/destination/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';
import '../test_utils/test_data/collection_reference_mock.dart';
import '../test_utils/test_data/document_mock.dart';
import '../test_utils/test_data/document_reference_mock.dart';
import '../test_utils/test_data/firestore_mock.dart';

// ignore_for_file: avoid_implementing_value_types, avoid_redundant_argument_values

void main() {
  group("FirestoreDestinationClientAdapter", () {
    const testProjectId = 'projectId';
    const testDocumentId = 'documentId';
    const builds = [
      BuildData(buildNumber: 1),
      BuildData(buildNumber: 2),
    ];
    const firestoreException = FirestoreException(null, [], null);
    const alreadyExistsFirestoreException =
        FirestoreException(FirestoreExceptionCode.alreadyExists, [], '');

    final currentDate = DateTime.now();
    final buildData = BuildData(
      buildNumber: 1,
      startedAt: currentDate,
      buildStatus: BuildStatus.failed,
      duration: const Duration(milliseconds: 100),
      workflowName: 'testWorkflowName',
      url: 'testUrl',
      coverage: Percent(0.1),
    );

    final buildDataTestJson = {
      'buildNumber': 1,
      'startedAt': currentDate,
      'buildStatus': '${BuildStatus.failed}',
      'duration': 100,
      'workflowName': 'testWorkflowName',
      'url': 'testUrl',
      'coverage': 0.1,
    };

    final _firestoreMock = FirestoreMock();
    final _collectionReferenceMock = CollectionReferenceMock();
    final _documentReferenceMock = DocumentReferenceMock();
    final _documentMock = DocumentMock();
    final adapter = FirestoreDestinationClientAdapter(_firestoreMock);

    final Matcher throwsDestinationError = throwsA(isA<DestinationError>());

    PostExpectation<Future<Document>> whenFetchProject({
      String collectionId = 'projects',
      String projectId = testProjectId,
    }) {
      when(_firestoreMock.document('$collectionId/$projectId'))
          .thenReturn(_documentReferenceMock);

      return when(_documentReferenceMock.get());
    }

    PostExpectation<bool> whenCheckProjectExists({
      String withProjectId = testProjectId,
    }) {
      whenFetchProject(
        projectId: withProjectId,
      ).thenAnswer((_) => Future.value(_documentMock));

      return when(_documentMock.exists);
    }

    PostExpectation<Future<List<Document>>> whenFetchLastBuild({
      String collectionId = 'build',
      String whereFieldPath = 'projectId',
      dynamic isEqualTo = testProjectId,
      String orderByFieldPath = 'startedAt',
      int limit = 1,
    }) {
      whenCheckProjectExists().thenReturn(true);
      when(_firestoreMock.collection(collectionId))
          .thenReturn(_collectionReferenceMock);
      when(_collectionReferenceMock.where(whereFieldPath, isEqualTo: isEqualTo))
          .thenReturn(_collectionReferenceMock);
      when(_collectionReferenceMock.orderBy(orderByFieldPath, descending: true))
          .thenReturn(_collectionReferenceMock);
      when(_collectionReferenceMock.limit(limit))
          .thenReturn(_collectionReferenceMock);
      return when(_collectionReferenceMock.getDocuments());
    }

    PostExpectation<Future<Document>> whenCreateBuild({
      Map<String, dynamic> withBuildJson,
    }) {
      when(
        _firestoreMock.collection('build'),
      ).thenReturn(_collectionReferenceMock);
      when(
        _collectionReferenceMock.document(argThat(startsWith(testProjectId))),
      ).thenReturn(_documentReferenceMock);

      return when(_documentReferenceMock.create(withBuildJson ?? any));
    }

    PostExpectation<Future<void>> whenSetBuild({
      Map<String, dynamic> withBuildJson,
    }) {
      when(
        _firestoreMock.collection('build'),
      ).thenReturn(_collectionReferenceMock);
      when(
        _collectionReferenceMock.document(argThat(startsWith(testProjectId))),
      ).thenReturn(_documentReferenceMock);

      return when(_documentReferenceMock.set(withBuildJson ?? any));
    }

    PostExpectation<Future<List<Document>>> whenFetchBuildsWithStatus({
      String withProjectId = testProjectId,
      BuildStatus withBuildStatus = BuildStatus.successful,
    }) {
      whenCheckProjectExists(withProjectId: withProjectId).thenReturn(true);

      when(
        _firestoreMock.collection('build'),
      ).thenReturn(_collectionReferenceMock);
      when(
        _collectionReferenceMock.where('projectId', isEqualTo: withProjectId),
      ).thenReturn(_collectionReferenceMock);
      when(
        _collectionReferenceMock.where(
          'buildStatus',
          isEqualTo: '$withBuildStatus',
        ),
      ).thenReturn(_collectionReferenceMock);

      return when(_collectionReferenceMock.getDocuments());
    }

    setUp(() {
      reset(_firestoreMock);
      reset(_collectionReferenceMock);
      reset(_documentReferenceMock);
      reset(_documentMock);
    });

    tearDown(() {
      reset(_collectionReferenceMock);
    });

    test(
      "throws an ArgumentError if the given Firestore is null",
      () {
        expect(
          () => FirestoreDestinationClientAdapter(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".addBuilds() throws an ArgumentError if a project with the given id does not exist",
      () {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.addBuilds(testProjectId, []);

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".addBuilds() throws a DestinationError if fetching a project throws",
      () {
        whenFetchProject().thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.addBuilds(testProjectId, []);

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".addBuilds() does not add builds if fetching a project throws",
      () async {
        whenFetchProject().thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.addBuilds(testProjectId, []);

        await expectLater(result, throwsDestinationError);
        verifyNever(_firestoreMock.collection('build'));
      },
    );

    test(
      ".addBuilds() does not add builds if a project with the given id does not exist",
      () async {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.addBuilds(testProjectId, []);

        await expectLater(result, throwsArgumentError);
        verifyNever(_firestoreMock.collection('build'));
      },
    );

    test(
      ".addBuilds() adds the given builds using the .set() method for finished builds",
      () async {
        whenCheckProjectExists().thenReturn(true);
        whenSetBuild().thenAnswer((_) => Future.value());
        whenCreateBuild().thenAnswer((_) => Future.value(_documentMock));

        const builds = [
          BuildData(buildNumber: 1, buildStatus: BuildStatus.successful),
          BuildData(buildNumber: 2, buildStatus: BuildStatus.failed),
          BuildData(buildNumber: 3, buildStatus: BuildStatus.inProgress),
        ];
        final buildJsons = builds
            .map((build) => build.copyWith(projectId: testProjectId).toJson())
            .toList();

        await adapter.addBuilds(testProjectId, builds);

        verify(
          _documentReferenceMock.set(buildJsons[0]),
        ).called(once);
        verify(
          _documentReferenceMock.set(buildJsons[1]),
        ).called(once);
        verifyNever(_documentReferenceMock.set(buildJsons[2]));
      },
    );

    test(
      ".addBuilds() adds the given builds using the .create() method for in-progress builds",
      () async {
        whenCheckProjectExists().thenReturn(true);
        whenCreateBuild().thenAnswer((_) => Future.value());

        const builds = [
          BuildData(buildNumber: 1, buildStatus: BuildStatus.inProgress),
          BuildData(buildNumber: 2, buildStatus: BuildStatus.inProgress),
          BuildData(buildNumber: 3, buildStatus: BuildStatus.successful),
        ];
        final buildJsons = builds
            .map((build) => build.copyWith(projectId: testProjectId).toJson())
            .toList();

        await adapter.addBuilds(testProjectId, builds);

        verify(
          _documentReferenceMock.create(buildJsons[0]),
        ).called(once);
        verify(
          _documentReferenceMock.create(buildJsons[1]),
        ).called(once);
        verifyNever(_documentReferenceMock.create(buildJsons[2]));
      },
    );

    test(
      ".addBuilds() adds builds in the given order",
      () async {
        whenCheckProjectExists().thenReturn(true);
        whenCreateBuild().thenAnswer((_) => Future.value(_documentMock));
        whenSetBuild().thenAnswer((_) => Future.value());
        const builds = [
          BuildData(buildNumber: 1),
          BuildData(buildNumber: 2, buildStatus: BuildStatus.inProgress),
        ];
        final buildsData = builds
            .map((build) => build.copyWith(projectId: testProjectId).toJson())
            .toList();

        await adapter.addBuilds(testProjectId, builds);

        verifyInOrder([
          _documentReferenceMock.set(buildsData[0]),
          _documentReferenceMock.create(buildsData[1]),
        ]);
      },
    );

    test(
      ".addBuilds() throws a DestinationError if adding a finished build fails",
      () {
        whenCheckProjectExists().thenReturn(true);
        whenSetBuild().thenAnswer((_) => Future.error(firestoreException));
        const builds = [BuildData(buildNumber: 1)];

        final result = adapter.addBuilds(testProjectId, builds);

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".addBuilds() throws a DestinationError if adding an in-progress build fails",
      () {
        whenCheckProjectExists().thenReturn(true);
        whenCreateBuild().thenAnswer((_) => Future.error(firestoreException));
        const builds = [
          BuildData(buildNumber: 1, buildStatus: BuildStatus.inProgress),
        ];

        final result = adapter.addBuilds(testProjectId, builds);

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".addBuilds() stops adding builds if adding a finished build fails",
      () async {
        whenCheckProjectExists().thenReturn(true);
        whenSetBuild().thenAnswer((_) => Future.value());

        const builds = [
          BuildData(buildNumber: 1),
          BuildData(buildNumber: 2),
          BuildData(buildNumber: 3),
        ];
        final buildsData = builds
            .map((build) => build.copyWith(projectId: testProjectId).toJson())
            .toList();

        whenSetBuild(
          withBuildJson: buildsData[1],
        ).thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.addBuilds(testProjectId, builds);

        await expectLater(result, throwsDestinationError);
        verify(_documentReferenceMock.set(buildsData[0])).called(once);
        verify(_documentReferenceMock.set(buildsData[1])).called(once);
        verifyNever(_documentReferenceMock.set(buildsData[2]));
      },
    );

    test(
      ".addBuilds() stops adding builds if adding an in-progress build fails",
      () async {
        whenCheckProjectExists().thenReturn(true);
        whenCreateBuild().thenAnswer((_) => Future.value(_documentMock));

        const builds = [
          BuildData(buildNumber: 1, buildStatus: BuildStatus.inProgress),
          BuildData(buildNumber: 2, buildStatus: BuildStatus.inProgress),
          BuildData(buildNumber: 3, buildStatus: BuildStatus.inProgress),
        ];
        final buildsData = builds
            .map((build) => build.copyWith(projectId: testProjectId).toJson())
            .toList();

        whenCreateBuild(
          withBuildJson: buildsData[1],
        ).thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.addBuilds(testProjectId, builds);

        await expectLater(result, throwsDestinationError);
        verify(_documentReferenceMock.create(buildsData[0])).called(once);
        verify(_documentReferenceMock.create(buildsData[1])).called(once);
        verifyNever(_documentReferenceMock.create(buildsData[2]));
      },
    );

    test(
      ".addBuilds() continues adding builds if adding an in-progress build fails with the already exists exception",
      () async {
        const builds = [
          BuildData(buildNumber: 1),
          BuildData(buildNumber: 2, buildStatus: BuildStatus.inProgress),
          BuildData(buildNumber: 3),
        ];
        final buildsData = builds
            .map((build) => build.copyWith(projectId: testProjectId).toJson())
            .toList();

        whenCheckProjectExists().thenReturn(true);
        whenSetBuild().thenAnswer((_) => Future.value());
        whenCreateBuild(
          withBuildJson: buildsData[1],
        ).thenAnswer((_) => Future.error(alreadyExistsFirestoreException));

        await adapter.addBuilds(testProjectId, builds);

        verify(_documentReferenceMock.set(buildsData[2])).called(once);
      },
    );

    test(
      ".fetchLastBuild() throws an DestinationError if fetching a project with the given id fails",
      () {
        whenFetchProject().thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.fetchLastBuild(testProjectId);

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".fetchLastBuild() throws an ArgumentError if a project with the given id is not found",
      () {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.fetchLastBuild(testProjectId);

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".fetchLastBuild() does not fetch the last build if the project with the given project id does not exist",
      () async {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.fetchLastBuild(testProjectId);

        await expectLater(result, throwsArgumentError);
        verifyNever(_firestoreMock.collection('build'));
      },
    );

    test(
      ".fetchLastBuild() returns null if there are no builds for a project with the given id",
      () {
        whenFetchLastBuild().thenAnswer((_) => Future.value([]));

        final result = adapter.fetchLastBuild(testProjectId);

        expect(result, completion(isNull));
      },
    );

    test(
      ".fetchLastBuild() returns the last build for a project with the given id",
      () {
        whenFetchLastBuild().thenAnswer((_) => Future.value([_documentMock]));
        when(_documentMock.id).thenReturn(testDocumentId);
        when(_documentMock.map).thenReturn(buildDataTestJson);

        final buildData = adapter.fetchLastBuild(testProjectId);
        final expectedBuildData = BuildDataDeserializer.fromJson(
          buildDataTestJson,
          testDocumentId,
        );

        expect(buildData, completion(equals(expectedBuildData)));
      },
    );

    test(
      ".fetchBuildsWithStatus() throws an ArgumentError if the given build status is null",
      () {
        expect(
          () => adapter.fetchBuildsWithStatus(testProjectId, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fetchBuildsWithStatus() throws a DestinationError if fetching a project with the given project id fails",
      () {
        whenFetchProject().thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".fetchBuildsWithStatus() throws an ArgumentError if the project with the given project id does not exist",
      () {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".fetchBuildsWithStatus() does not fetch builds if the project with the given project id does not exist",
      () async {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        await expectLater(result, throwsArgumentError);
        verifyNever(_firestoreMock.collection('build'));
      },
    );

    test(
      ".fetchBuildsWithStatus() references the 'build' collection",
      () async {
        whenFetchBuildsWithStatus().thenAnswer((_) => Future.value([]));

        await adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        verify(_firestoreMock.collection('build')).called(once);
      },
    );

    test(
      ".fetchBuildsWithStatus() filters builds with the given project id",
      () async {
        whenFetchBuildsWithStatus().thenAnswer((_) => Future.value([]));

        await adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        verify(
          _collectionReferenceMock.where('projectId', isEqualTo: testProjectId),
        ).called(once);
      },
    );

    test(
      ".fetchBuildsWithStatus() filters builds with the given build status",
      () async {
        const buildStatus = BuildStatus.inProgress;
        whenFetchBuildsWithStatus(
          withBuildStatus: buildStatus,
        ).thenAnswer((_) => Future.value([]));

        await adapter.fetchBuildsWithStatus(
          testProjectId,
          buildStatus,
        );

        verify(
          _collectionReferenceMock.where(
            'buildStatus',
            isEqualTo: '$buildStatus',
          ),
        ).called(once);
      },
    );

    test(
      ".fetchBuildsWithStatus() gets documents after filtering them with the given project id and build status",
      () async {
        const buildStatus = BuildStatus.inProgress;
        whenFetchBuildsWithStatus(withBuildStatus: buildStatus).thenAnswer(
          (_) => Future.value([]),
        );

        await adapter.fetchBuildsWithStatus(
          testProjectId,
          buildStatus,
        );

        verify(_collectionReferenceMock.getDocuments()).called(once);
      },
    );

    test(
      ".fetchBuildsWithStatus() returns builds with the requested status",
      () async {
        when(_documentMock.map).thenReturn(buildDataTestJson);
        whenFetchBuildsWithStatus().thenAnswer(
          (_) => Future.value([_documentMock]),
        );

        final result = await adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        expect(result, equals([buildData]));
      },
    );

    test(
      ".fetchBuildsWithStatus() throws a DestinationError if reading documents fails",
      () {
        whenFetchBuildsWithStatus().thenAnswer(
          (_) => Future.error(firestoreException),
        );

        final result = adapter.fetchBuildsWithStatus(
          testProjectId,
          BuildStatus.successful,
        );

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".updateBuilds() throws an ArgumentError if the given builds list is null",
      () {
        expect(
          () => adapter.updateBuilds(testProjectId, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".updateBuilds() throws a DestinationError if fetching a project with the given project id fails",
      () {
        whenFetchProject().thenAnswer((_) => Future.error(firestoreException));

        final result = adapter.updateBuilds(testProjectId, []);

        expect(result, throwsDestinationError);
      },
    );

    test(
      ".updateBuilds() throws an ArgumentError if a project with the given id does not exist",
      () {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.updateBuilds(testProjectId, []);

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".updateBuilds() does not update builds if the project with the given project id does not exist",
      () async {
        whenCheckProjectExists().thenReturn(false);

        final result = adapter.updateBuilds(testProjectId, builds);

        await expectLater(result, throwsArgumentError);
        verifyNever(_firestoreMock.collection('build'));
      },
    );

    test(
      ".updateBuilds() references builds using their ids",
      () async {
        whenCheckProjectExists().thenReturn(true);
        when(
          _firestoreMock.document(argThat(startsWith('build/'))),
        ).thenReturn(_documentReferenceMock);
        when(_documentReferenceMock.update(any)).thenAnswer(
          (_) => Future.sync(() {}),
        );

        await adapter.updateBuilds(testProjectId, builds);

        verifyInOrder([
          for (final build in builds)
            _firestoreMock.document('build/${build.id}'),
        ]);
      },
    );

    test(
      ".updateBuilds() updates builds with the given builds data in the given order",
      () async {
        const projectId = 'id';
        final expectedBuilds = builds.map(
          (build) => build.copyWith(projectId: projectId),
        );
        whenCheckProjectExists(withProjectId: projectId).thenReturn(true);
        when(
          _firestoreMock.document(argThat(startsWith('build/'))),
        ).thenReturn(_documentReferenceMock);
        when(_documentReferenceMock.update(any)).thenAnswer(
          (_) => Future.sync(() {}),
        );

        await adapter.updateBuilds(projectId, builds);

        verifyInOrder([
          for (final build in expectedBuilds)
            _documentReferenceMock.update(build.toJson()),
        ]);
      },
    );

    test(
      ".updateBuilds() continues updating other builds if updating one fails",
      () async {
        const firstBuild = BuildData(buildNumber: 1, projectId: testProjectId);
        const secondBuild = BuildData(buildNumber: 2, projectId: testProjectId);
        const builds = [firstBuild, secondBuild];

        whenCheckProjectExists().thenReturn(true);
        when(
          _firestoreMock.document(argThat(startsWith('build/'))),
        ).thenReturn(_documentReferenceMock);
        when(_documentReferenceMock.update(firstBuild.toJson())).thenAnswer(
          (_) => Future.error(firestoreException),
        );
        when(_documentReferenceMock.update(secondBuild.toJson())).thenAnswer(
          (_) => Future.sync(() {}),
        );

        await adapter.updateBuilds(testProjectId, builds);

        verify(
          _documentReferenceMock.update(secondBuild.toJson()),
        ).called(once);
      },
    );
  });
}
