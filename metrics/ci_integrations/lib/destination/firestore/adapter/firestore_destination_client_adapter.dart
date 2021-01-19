import 'dart:async';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:ci_integration/data/deserializer/build_data_deserializer.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:grpc/grpc.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides methods for interactions between
/// [CiIntegration] and Firestore destination storage.
class FirestoreDestinationClientAdapter implements DestinationClient {
  final Firestore _firestore;

  /// Creates a [FirestoreDestinationClientAdapter] instance
  /// with the given [Firestore] instance.
  ///
  /// Throws an [ArgumentError], if the given [Firestore] instance is `null`.
  FirestoreDestinationClientAdapter(this._firestore) {
    ArgumentError.checkNotNull(_firestore, 'firestore');
  }

  @override
  Future<void> addBuilds(String projectId, List<BuildData> builds) async {
    Map<String, dynamic> buildJson;

    try {
      final project =
          await _firestore.collection('projects').document(projectId).get();
      Logger.logInfo(
        'FirestoreDestinationClientAdapter: Getting a project with the project id #$projectId ...',
      );
      final collection = _firestore.collection('build');

      Logger.logInfo('FirestoreDestinationClientAdapter: Adding builds...');
      for (final build in builds) {
        final documentId = '${project.id}_${build.buildNumber}';
        final map = build.copyWith(projectId: project.id).toJson();
        buildJson = map;

        await collection.document(documentId).create(map);
        Logger.logInfo(
            'FirestoreDestinationClientAdapter: Added build #$documentId.');
      }
    } on GrpcError catch (e) {
      Logger.logInfo('FirestoreDestinationClientAdapter: Error: ${e.message}');
      if (buildJson != null) Logger.logInfo(buildJson);
      buildJson = null;

      if (e.code == StatusCode.notFound) return;
      rethrow;
    }
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) async {
    Logger.logInfo(
      'FirestoreDestinationClientAdapter: Fetching last build for the project id #$projectId...',
    );
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
  void dispose() {}
}
