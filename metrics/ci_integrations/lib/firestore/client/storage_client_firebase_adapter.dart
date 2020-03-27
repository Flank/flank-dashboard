import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/deserializer/build_data_deserializer.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides methods for interactions between
/// [CiIntegration] and Firebase builds storage.
class StorageClientFirebaseAdapter extends StorageClient {
  final Firestore _firestore;

  StorageClientFirebaseAdapter(this._firestore);

  @override
  Future<void> addBuilds(String projectId, List<BuildData> builds) async {
    final project = await _firestore
        .collection('projects')
        .document(projectId)
        .get()
        .catchError(print);

    if (project == null) {
      return;
    }

    final collection = _firestore.collection('build');
    for (final build in builds) {
      await collection.add(
        build.toJson()
          ..addAll(
            {'projectId': project.id},
          ),
      );
    }
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) {
    return _firestore
        .collection('build')
        .where('projectId', isEqualTo: projectId)
        .orderBy('startedAt', descending: true)
        .limit(1)
        .getDocuments()
        .then(
      (documents) {
        if (documents.isEmpty) {
          return null;
        } else {
          final document = documents.first;
          return BuildDataDeserializer.fromJson(document.map, document.id);
        }
      },
    );
  }
}
