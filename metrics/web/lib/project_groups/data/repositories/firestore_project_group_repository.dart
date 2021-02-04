// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';

/// An implementation of the [ProjectGroupRepository] for [Firestore].
class FirestoreProjectGroupsRepository implements ProjectGroupRepository {
  final Firestore _firestore = Firestore.instance;

  @override
  Stream<List<ProjectGroup>> projectGroupsStream() {
    return _firestore
        .collection('project_groups')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => ProjectGroupData.fromJson(
                  doc.data,
                  doc.documentID,
                ),
              )
              .toList(),
        )
        .handleError((_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.unknown,
      );
    });
  }

  @override
  Future<void> addProjectGroup(
    String projectGroupName,
    List<String> projectIds,
  ) async {
    final projectGroupData = ProjectGroupData(
      name: projectGroupName,
      projectIds: projectIds,
    );

    try {
      await _firestore.collection('project_groups').add(
            projectGroupData.toJson(),
          );
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.unknown,
      );
    }
  }

  @override
  Future<void> updateProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  ) async {
    final projectGroupData = ProjectGroupData(
      name: projectGroupName,
      projectIds: projectIds,
    );

    try {
      await _firestore
          .collection('project_groups')
          .document(projectGroupId)
          .updateData(
            projectGroupData.toJson(),
          );
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.unknown,
      );
    }
  }

  @override
  Future<void> deleteProjectGroup(String projectGroupId) async {
    try {
      await _firestore
          .collection('project_groups')
          .document(projectGroupId)
          .delete();
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.unknown,
      );
    }
  }
}
