import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/features/dashboard/data/model/build_data.dart';
import 'package:metrics/features/dashboard/data/model/project_data.dart';
import 'package:metrics/features/dashboard/domain/entities/core/build.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';

/// Loads data from [Firestore].
class FirestoreMetricsRepository implements MetricsRepository {
  final Firestore _firestore = Firestore.instance;

  @override
  Stream<List<Project>> projectsStream() {
    return _firestore.collection('projects').orderBy('name').snapshots().map(
        (snapshot) => snapshot.documents
            .map((doc) => ProjectData.fromJson(doc.data, doc.documentID))
            .toList());
  }

  @override
  Stream<List<Build>> latestProjectBuildsStream(String projectId, int limit) {
    return _firestore
        .collection('build')
        .where('projectId', isEqualTo: projectId)
        .orderBy('startedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => BuildData.fromJson(doc.data, doc.documentID))
            .toList());
  }

  @override
  Stream<List<Build>> projectBuildsFromDateStream(
    String projectId,
    DateTime from,
  ) {
    return _firestore
        .collection('build')
        .orderBy('startedAt', descending: true)
        .where('projectId', isEqualTo: projectId)
        .where('startedAt', isGreaterThanOrEqualTo: from)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => BuildData.fromJson(doc.data, doc.documentID))
            .toList());
  }
}
