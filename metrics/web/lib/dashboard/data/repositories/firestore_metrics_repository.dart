// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/dashboard/data/deserializer/build_data_deserializer.dart';
import 'package:metrics/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics_core/metrics_core.dart' hide BuildDataDeserializer;

/// An implementation of the [MetricsRepository] for [Firestore].
class FirestoreMetricsRepository implements MetricsRepository {
  final Firestore _firestore = Firestore.instance;

  @override
  Stream<List<Build>> latestProjectBuildsStream(String projectId, int limit) {
    return _firestore
        .collection('build')
        .where('projectId', isEqualTo: projectId)
        .orderBy('startedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) =>
                BuildDataDeserializer.fromJson(doc.data, doc.documentID))
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
            .map((doc) =>
                BuildDataDeserializer.fromJson(doc.data, doc.documentID))
            .toList());
  }

  @override
  Stream<List<Build>> lastSuccessfulBuildStream(String projectId) {
    return _firestore
        .collection('build')
        .orderBy('startedAt', descending: true)
        .where('projectId', isEqualTo: projectId)
        .where('buildStatus', isEqualTo: BuildStatus.successful.toString())
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) =>
                BuildDataDeserializer.fromJson(doc.data, doc.documentID))
            .toList());
  }
}
