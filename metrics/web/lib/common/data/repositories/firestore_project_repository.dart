import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/common/domain/repositories/project_repository.dart';
import 'package:metrics_core/metrics_core.dart';

/// An implementation of the [ProjectRepository] for [Firestore].
class FirestoreProjectRepository implements ProjectRepository {
  final Firestore _firestore = Firestore.instance;

  @override
  Stream<List<Project>> projectsStream() {
    return _firestore.collection('projects').orderBy('name').snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => ProjectData.fromJson(doc.data, doc.documentID))
            .toList());
  }
}
