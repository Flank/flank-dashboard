import 'package:ci_integration/firestore/deserializer/build_data_deserializer.dart';
import 'package:ci_integration/firestore/adapter/firestore_storage_client_adapter.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart';

void main() {
  group("FirestoreStorageClientAdapter", () {
    const projectId = 'projectId';
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
    final collectionReferenceMock = _CollectionReferenceMock();
    final documentReferenceMock = _DocumentReferenceMock();
    final firestoreMock = _FirestoreMock();
    final mockAdapter = FirestoreStorageClientAdapter(firestoreMock);

    reset(collectionReferenceMock);
    reset(documentReferenceMock);
    reset(firestoreMock);
    reset(mockAdapter);

    setUp(() {
      when(firestoreMock.collection('projects')).thenReturn(
        collectionReferenceMock,
      );
      when(firestoreMock.collection('build')).thenReturn(
        collectionReferenceMock,
      );
      when(collectionReferenceMock.document(projectId)).thenReturn(
        documentReferenceMock,
      );
      when(collectionReferenceMock.where('projectId', isEqualTo: projectId))
          .thenReturn(
        collectionReferenceMock,
      );
      when(collectionReferenceMock.orderBy('startedAt', descending: true))
          .thenReturn(
        collectionReferenceMock,
      );
      when(collectionReferenceMock.limit(1)).thenReturn(
        collectionReferenceMock,
      );
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
        when(documentReferenceMock.get()).thenThrow(GrpcError.notFound());
        expect(() => mockAdapter.addBuilds(projectId, []), returnsNormally);
      },
    );

    test(
      ".addBuilds() should throw Exception if the firestore throws exception different from GrpcError.notFound",
      () {
        when(documentReferenceMock.get()).thenThrow(Exception());
        expect(() => mockAdapter.addBuilds(projectId, []), throwsException);
      },
    );

    test(
      ".addBuilds() should rethrow GrpcError with status different from 'notFound'",
      () {
        when(documentReferenceMock.get()).thenThrow(GrpcError.cancelled());
        expect(() => mockAdapter.addBuilds(projectId, []), throwsException);
      },
    );

    test(
      ".addBuilds() ensure that methods isnot called after throws GrpcError.notFound",
      () async {
        when(documentReferenceMock.get()).thenThrow(GrpcError.notFound());
        await mockAdapter.addBuilds(projectId, []);
        verifyNever(firestoreMock.collection('build'));
      },
    );

    test(
        ".fetchLastBuild() should return null, if there are no builds for a project with the given id",
        () {
      when(collectionReferenceMock.getDocuments()).thenAnswer(
        (_) => Future.value([]),
      );
      final result = mockAdapter.fetchLastBuild(projectId);
      expect(result, completion(isNull));
    });

    test(
      ".fetchLastBuild() should return the last build for a project with the given id",
      () {
        final documentMock = _DocumentMock();

        when(documentMock.id).thenReturn(testDocumentId);
        when(documentMock.map).thenReturn(buildDataTestJson);
        when(collectionReferenceMock.getDocuments()).thenAnswer(
          (_) => Future.value([documentMock]),
        );
        expect(
          mockAdapter.fetchLastBuild(projectId),
          completion(
            equals(
              BuildDataDeserializer.fromJson(
                buildDataTestJson,
                testDocumentId,
              ),
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
