import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/deserializer/build_data_deserializer.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides methods for interactions between
/// [CiIntegration] and Firebase builds storage.
class StorageClientFirebaseAdapter implements StorageClient {
  final Firestore _firestore;

  /// Creates a [StorageClientFirebaseAdapter] instance
  /// with the given [Firestore].
  ///
  /// Throws [ArgumentError] if [Firestore] is `null`.
  StorageClientFirebaseAdapter(this._firestore) {
    ArgumentError.checkNotNull(_firestore, '_firestore');
  }

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
    final futures = <Future>[];
    for (final build in builds) {
      futures.add(collection.add(
        build.toJson()
          ..addAll(
            {'projectId': project.id},
          ),
      ));
    }
    await Future.wait(futures);
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) async {
    final documents = await _firestore
        .collection('build')
        .where('projectId', isEqualTo: projectId)
        .orderBy('startedAt', descending: true)
        .limit(1)
        .getDocuments();

    if (documents.isEmpty) {
      return null;
    }

    final document = documents.first;
    return BuildDataDeserializer.fromJson(document.map, document.id);
  }
}
