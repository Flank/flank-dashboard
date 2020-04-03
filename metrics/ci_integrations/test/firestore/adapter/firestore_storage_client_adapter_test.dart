import 'package:ci_integration/firestore/deserializer/build_data_deserializer.dart';
import 'package:ci_integration/firestore/adapter/firestore_storage_client_adapter.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart';

void main() {
  group('FirestoreStorageClientAdapter', () {
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
    final documentReferenceMock = _DocumentReferenceMock();
    final collectionAddBuildsMock = _CollectionReferenceMockAddBuilds(
      projectId: projectId,
      documentReferenceMock: documentReferenceMock,
    );
    final collectionFetchBuildsMock = _CollectionReferenceMockFetchBuild(
      projectId: projectId,
    );
    final firestoreMock =
        _FirestoreMock(collectionAddBuildsMock, collectionFetchBuildsMock);
    final mockAdapter = FirestoreStorageClientAdapter(firestoreMock);

    test(
      'should throw ArgumentError trying to create an instance '
      'with null Firestore',
      () {
        expect(() => FirestoreStorageClientAdapter(null), throwsArgumentError);
      },
    );

    test(
      '.addBuilds() should return normally if it throws GrpcError '
      'with status code "not found"',
      () {
        when(documentReferenceMock.get()).thenThrow(GrpcError.notFound());
        expect(() => mockAdapter.addBuilds(projectId, []), returnsNormally);
      },
    );

    test(
      '.addBuilds() should throw Exception if the exception '
      'is different from GrpcError with status code "not found"',
      () {
        when(documentReferenceMock.get()).thenThrow(Exception());
        expect(() => mockAdapter.addBuilds(projectId, []), throwsException);
      },
    );

    test(
      '.addBuilds() ensure that methods isnot called after throws GrpcError '
      'with status code "not fount" ',
      () async {
        when(documentReferenceMock.get()).thenThrow(GrpcError.notFound());
        await mockAdapter.addBuilds(projectId, []);
        verifyNever(firestoreMock.collection('build'));
      },
    );

    test('.fetchLastBuild should return null, if documents is empty', () {
      when(collectionFetchBuildsMock.getDocuments()).thenAnswer(
        (_) => Future.value([]),
      );
      expect(mockAdapter.fetchLastBuild(projectId), completion(equals(null)));
    });

    test(
      '.fetchLastBuild should return BuildData, if documents is not empty',
      () {
        final documentMock = _DocumentMock(testDocumentId, buildDataTestJson);

        when(collectionFetchBuildsMock.getDocuments()).thenAnswer(
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

class _FirestoreMock extends Mock implements Firestore {
  _FirestoreMock(_CollectionReferenceMockAddBuilds collectionAddBuilds,
      _CollectionReferenceMockFetchBuild collectionFetchBuild) {
    when(collection('projects')).thenReturn(collectionAddBuilds);
    when(collection('build')).thenReturn(collectionFetchBuild);
  }
}

class _CollectionReferenceMockAddBuilds extends Mock
    implements CollectionReference {
  _CollectionReferenceMockAddBuilds({
    String projectId,
    _DocumentReferenceMock documentReferenceMock,
  }) {
    when(document(projectId)).thenReturn(documentReferenceMock);
  }
}

class _CollectionReferenceMockFetchBuild extends Mock
    implements CollectionReference {
  _CollectionReferenceMockFetchBuild({
    String projectId,
  }) {
    when(where('projectId', isEqualTo: projectId)).thenReturn(this);
    when(orderBy('startedAt', descending: true)).thenReturn(this);
    when(limit(1)).thenReturn(this);
  }
}

class _DocumentReferenceMock extends Mock implements DocumentReference {}

class _DocumentMock extends Mock implements Document {
  _DocumentMock(String testDocumentId, Map<String, dynamic> buildDataJson) {
    when(id).thenReturn(testDocumentId);
    when(map).thenReturn(buildDataJson);
  }
}
