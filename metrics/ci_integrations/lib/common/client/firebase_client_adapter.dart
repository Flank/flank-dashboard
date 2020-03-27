import 'package:ci_integration/common/client/storage_client.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';

class FirebaseClientAdapter extends StorageClient {
  final Firestore _firestore;

  FirebaseClientAdapter(this._firestore);

  @override
  Future<void> addBuilds(String projectId, List<BuildData> builds) async {
    final collection = _firestore.collection('build');
    for (final build in builds) {
      await collection.add(
        build.toJson(),
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
          return BuildData.fromJson(document.map, document.id);
        }
      },
    );
  }
}
