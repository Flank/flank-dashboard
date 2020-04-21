import 'dart:async';

import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/firestore/deserializer/build_data_deserializer.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:grpc/grpc.dart';

/// A class that provides methods for interactions between
/// [CiIntegration] and Firestore builds storage.
class FirestoreDestinationClientAdapter implements DestinationClient {
  final Firestore _firestore;

  /// Creates a [FirestoreDestinationClientAdapter] instance
  /// with the given [Firestore].
  ///
  /// Throws [ArgumentError] if [Firestore] is `null`.
  FirestoreDestinationClientAdapter(this._firestore) {
    ArgumentError.checkNotNull(_firestore, 'firestore');
  }

  @override
  Future<void> addBuilds(String projectId, List<BuildData> builds) async {
    try {
      final project =
          await _firestore.collection('projects').document(projectId).get();
      final collection = _firestore.collection('build');

      for (final build in builds) {
        final documentId = '${project.id}_${build.buildNumber}';
        final map = build.copyWith(projectId: project.id).toJson();
        await collection.document(documentId).create(map);
      }
    } on GrpcError catch (e) {
      if (e.code == StatusCode.notFound) return;
      rethrow;
    }
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) async {
    final documents = await _firestore
        .collection('build')
        .where('projectId', isEqualTo: projectId)
        .orderBy('startedAt', descending: true)
        .limit(1)
        .getDocuments();

    if (documents.isEmpty) return null;

    final document = documents.first;
    return BuildDataDeserializer.fromJson(document.map, document.id);
  }

  @override
  FutureOr<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}
