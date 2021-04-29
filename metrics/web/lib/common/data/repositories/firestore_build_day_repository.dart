// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/common/data/model/build_day_data.dart';
import 'package:metrics/common/domain/entities/build_day.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/domain/repositories/build_day_repository.dart';

/// An implementation of the [BuildDayRepository] for [Firestore].
class FirestoreBuildDayRepository implements BuildDayRepository {
  /// A [Firestore] instance this repository uses to interact with the
  /// Firestore database.
  final Firestore _firestore = Firestore.instance;

  @override
  Stream<List<BuildDay>> projectBuildDaysInDateRangeStream(
    String projectId, {
    DateTime from,
    DateTime to,
  }) {
    ArgumentError.checkNotNull(projectId, 'projectId');

    final collection = _firestore.collection('build');

    Query query = collection.where('projectId', isEqualTo: projectId);

    if (from != null) query = query.where('day', isGreaterThanOrEqualTo: from);
    if (to != null) query = query.where('day', isLessThanOrEqualTo: to);

    return query
        .orderBy('day')
        .snapshots()
        .map(_mapSnapshotToBuildDays)
        .handleError(_handleError);
  }

  /// Maps the given [snapshot] to a [List] of [BuildDayData].
  List<BuildDayData> _mapSnapshotToBuildDays(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => BuildDayData.fromJson(doc.data))
        .toList();
  }

  /// Handles the given [error] occurred while fetching [BuildDay]s.
  ///
  /// Throws a [PersistentStoreException] with the
  /// [PersistentStoreErrorCode.unknown] code.
  void _handleError(Object error) {
    throw const PersistentStoreException(
      code: PersistentStoreErrorCode.unknown,
    );
  }
}
