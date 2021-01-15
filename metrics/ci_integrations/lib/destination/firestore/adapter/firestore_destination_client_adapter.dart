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
    try {
      final project =
          await _firestore.collection('projects').document(projectId).get();
      Logger.printLog(
        'Firestore: getting a project with the project id #$projectId',
      );
      final collection = _firestore.collection('build');

      Logger.printLog('Firestore: adding builds...');
      for (final build in builds) {
        final documentId = '${project.id}_${build.buildNumber}';
        final map = build.copyWith(projectId: project.id).toJson();
        await collection.document(documentId).create(map);
        Logger.printLog('Firestore: added build #$documentId');
      }
    } on GrpcError catch (e) {
      Logger.printLog('Firestore: Error: ${e.message}');
      if (e.code == StatusCode.notFound) return;
      rethrow;
    }
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) async {
    Logger.printLog(
      'Firestore: fetching last builds for the project id #$projectId',
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
