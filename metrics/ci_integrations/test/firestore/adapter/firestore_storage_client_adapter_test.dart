// ignore_for_file: avoid_implementing_value_types

import 'package:ci_integration/firestore/adapter/firestore_storage_client_adapter.dart';
import 'package:ci_integration/firestore/deserializer/build_data_deserializer.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart';

void main() {
  group("FirestoreStorageClientAdapter", () {
    const testProjectId = 'projectId';
    const testDocumentId = 'documentId';
    final buildDataTestJson = {
      'buildNumber': 1,
      'startedAt': DateTime.now(),
      'buildStatus': BuildStatus.failed.toString(),
      'duration': 100,
      'workflowName': 'testWorkflowName',
      'url': 'testUrl',
      'coverage': 0.1,
    };
    final _firestoreMock = _FirestoreMock();
    final _collectionReferenceMock = _CollectionReferenceMock();
    final _documentReferenceMock = _DocumentReferenceMock();
    final _documentMock = _DocumentMock();
    final mockAdapter = FirestoreStorageClientAdapter(_firestoreMock);

    PostExpectation<Future<Document>> whenFetchProject({
      String collectionId = 'projects',
      String projectId = testProjectId,
    }) {
      when(_firestoreMock.collection(collectionId))
          .thenReturn(_collectionReferenceMock);
      when(_collectionReferenceMock.document(projectId))
          .thenReturn(_documentReferenceMock);
      return when(_documentReferenceMock.get());
    }

    PostExpectation<Future<List<Document>>> whenFetchLastBuild({
      String collectionId = 'build',
      String whereFieldPath = 'projectId',
      dynamic isEqualTo = testProjectId,
      String orderByFieldPath = 'startedAt',
      int limit = 1,
    }) {
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

    setUp(() {
      reset(_firestoreMock);
      reset(_collectionReferenceMock);
      reset(_documentReferenceMock);
      reset(_documentMock);
    });

    test(
      "should throw ArgumentError trying to create an instance with null Firestore",
      () {
        expect(() => FirestoreStorageClientAdapter(null), throwsArgumentError);
      },
    );

    test(
      ".addBuilds() should return normally if firestore throws GrpcError.notFound",
      () {
        whenFetchProject().thenThrow(GrpcError.notFound());

        final result = mockAdapter.addBuilds(testProjectId, []);

        expect(result, completes);
      },
    );

    test(
      ".addBuilds() should throw Exception if the firestore throws exception different from GrpcError.notFound",
      () {
        whenFetchProject().thenThrow(Exception());
        expect(() => mockAdapter.addBuilds(testProjectId, []), throwsException);
      },
    );

    test(
      ".addBuilds() should rethrow GrpcError with status different from 'notFound'",
      () {
        final error = GrpcError.cancelled();

        whenFetchProject().thenThrow(error);
        expect(
          () => mockAdapter.addBuilds(testProjectId, []),
          throwsA(equals(error)),
        );
      },
    );

    test(
      ".addBuilds() should not add builds if fetching the project throws",
      () async {
        whenFetchProject().thenThrow(GrpcError.notFound());

        await mockAdapter.addBuilds(testProjectId, []);

        verifyNever(_firestoreMock.collection('build'));
      },
    );

    test(
        ".fetchLastBuild() should return null, if there are no builds for a project with the given id",
        () {
      whenFetchLastBuild().thenAnswer((_) => Future.value([]));

      final result = mockAdapter.fetchLastBuild(testProjectId);

      expect(result, completion(isNull));
    });

    test(
      ".fetchLastBuild() should return the last build for a project with the given id",
      () {
        whenFetchLastBuild().thenAnswer((_) => Future.value([_documentMock]));
        when(_documentMock.id).thenReturn(testDocumentId);
        when(_documentMock.map).thenReturn(buildDataTestJson);

        final buildData = mockAdapter.fetchLastBuild(testProjectId);
        final expectedBuildData = BuildDataDeserializer.fromJson(
          buildDataTestJson,
          testDocumentId,
        );

        expect(
          buildData,
          completion(
            equals(
              expectedBuildData,
            ),
          ),
        );
      },
    );
  });
}

class _FirestoreMock extends Mock implements Firestore {}

class _CollectionReferenceMock extends Mock implements CollectionReference {}

class _DocumentReferenceMock extends Mock implements DocumentReference {}

class _DocumentMock extends Mock implements Document {}
