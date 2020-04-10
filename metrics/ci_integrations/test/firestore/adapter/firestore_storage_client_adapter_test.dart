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

    final firestoreStorageAdapterMockManager =
        _FirestoreStorageAdapterMockManager();

    final mockAdapter = firestoreStorageAdapterMockManager.initMockAdapter();

    setUp(() {
      firestoreStorageAdapterMockManager.resetMocks();
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
        firestoreStorageAdapterMockManager.mockAddBuildsBasic(
          collectionId: 'projects',
          projectId: projectId,
        );
        firestoreStorageAdapterMockManager.mockThrowDocumentGet(
          exception: GrpcError.notFound(),
        );
        expect(() => mockAdapter.addBuilds(projectId, []), returnsNormally);
      },
    );

    test(
      ".addBuilds() should throw Exception if the firestore throws exception different from GrpcError.notFound",
      () {
        firestoreStorageAdapterMockManager.mockAddBuildsBasic(
          collectionId: 'projects',
          projectId: projectId,
        );
        firestoreStorageAdapterMockManager.mockThrowDocumentGet(
          exception: Exception(),
        );
        expect(() => mockAdapter.addBuilds(projectId, []), throwsException);
      },
    );

    test(
      ".addBuilds() should rethrow GrpcError with status different from 'notFound'",
      () {
        firestoreStorageAdapterMockManager.mockAddBuildsBasic(
          collectionId: 'projects',
          projectId: projectId,
        );
        firestoreStorageAdapterMockManager.mockThrowDocumentGet(
          exception: GrpcError.cancelled(),
        );
        expect(() => mockAdapter.addBuilds(projectId, []), throwsException);
      },
    );

    test(
      ".addBuilds() ensure that methods is not called after throws GrpcError.notFound",
      () async {
        firestoreStorageAdapterMockManager.mockAddBuildsBasic(
          collectionId: 'projects',
          projectId: projectId,
        );
        firestoreStorageAdapterMockManager.mockThrowDocumentGet(
          exception: GrpcError.notFound(),
        );
        await mockAdapter.addBuilds(projectId, []);
        verifyNever(firestoreStorageAdapterMockManager._firestoreMock
            .collection('build'));
      },
    );

    test(
        ".fetchLastBuild() should return null, if there are no builds for a project with the given id",
        () {
      firestoreStorageAdapterMockManager.mockFetchBuildBasic(
        collectionId: 'build',
        projectId: projectId,
      );
      firestoreStorageAdapterMockManager
          .mockCollectionGetDocuments(Future.value([]));

      final result = mockAdapter.fetchLastBuild(projectId);

      expect(result, completion(isNull));
    });

    test(
      ".fetchLastBuild() should return the last build for a project with the given id",
      () async {
        firestoreStorageAdapterMockManager.mockFetchBuildBasic(
          collectionId: 'build',
          projectId: projectId,
        );

        firestoreStorageAdapterMockManager.mockDocumentId(id: testDocumentId);
        firestoreStorageAdapterMockManager.mockDocumentMap(
            buildDataJson: buildDataTestJson);
        firestoreStorageAdapterMockManager.mockCollectionGetDocuments(
          Future.value([firestoreStorageAdapterMockManager._documentMock]),
        );

        final buildData = mockAdapter.fetchLastBuild(projectId);
        expect(
          buildData,
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

class _FirestoreStorageAdapterMockManager {
  final _FirestoreMock _firestoreMock = _FirestoreMock();
  final _CollectionReferenceMock _collectionReferenceMock =
      _CollectionReferenceMock();
  final _DocumentReferenceMock _documentReferenceMock =
      _DocumentReferenceMock();
  final _DocumentMock _documentMock = _DocumentMock();

  FirestoreStorageClientAdapter initMockAdapter() {
    return FirestoreStorageClientAdapter(_firestoreMock);
  }

  void resetMocks() {
    reset(_firestoreMock);
    reset(_collectionReferenceMock);
    reset(_documentReferenceMock);
    reset(_documentMock);
  }

  void mockCollectionId({
    String collectionId,
  }) {
    when(_firestoreMock.collection(collectionId))
        .thenReturn(_collectionReferenceMock);
  }

  void mockCollectionWhere({
    String fieldPath,
    String isEqualTo,
  }) {
    when(
      _collectionReferenceMock.where(fieldPath, isEqualTo: isEqualTo),
    ).thenReturn(
      _collectionReferenceMock,
    );
  }

  void mockCollectionOrderBy({
    String fieldPath,
  }) {
    when(
      _collectionReferenceMock.orderBy(fieldPath, descending: true),
    ).thenReturn(
      _collectionReferenceMock,
    );
  }

  void mockCollectionLimit({
    int limit,
  }) {
    when(
      _collectionReferenceMock.limit(limit),
    ).thenReturn(
      _collectionReferenceMock,
    );
  }

  void mockCollectionGetDocuments(Future<List<Document>> futureDocuments) {
    when(_collectionReferenceMock.getDocuments())
        .thenAnswer((realInvocation) => futureDocuments);
  }

  void mockDocumentReferenceId({
    String documentId,
  }) {
    when(_collectionReferenceMock.document(documentId)).thenReturn(
      _documentReferenceMock,
    );
  }

  void mockThrowDocumentGet({
    Exception exception,
  }) {
    when(_documentReferenceMock.get()).thenThrow(exception);
  }

  void mockDocumentId({String id}) {
    when(_documentMock.id).thenReturn(id);
  }

  void mockDocumentMap({Map<String, dynamic> buildDataJson}) {
    when(_documentMock.map).thenReturn(buildDataJson);
  }

  void mockFetchBuildBasic({
    String collectionId,
    String projectId,
  }) {
    mockCollectionId(collectionId: collectionId);
    mockCollectionWhere(fieldPath: 'projectId', isEqualTo: projectId);
    mockCollectionOrderBy(fieldPath: 'startedAt');
    mockCollectionLimit(limit: 1);
  }

  void mockAddBuildsBasic({
    String collectionId,
    String projectId,
  }) {
    mockCollectionId(collectionId: collectionId);
    mockDocumentReferenceId(documentId: projectId);
  }
}

class _FirestoreMock extends Mock implements Firestore {}

class _CollectionReferenceMock extends Mock implements CollectionReference {}

class _DocumentReferenceMock extends Mock implements DocumentReference {}

class _DocumentMock extends Mock implements Document {}
