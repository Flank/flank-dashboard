import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/project_groups/data/model/project_group_data.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';

/// Loads data from [Firestore].
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
        );
  }

  @override
  Future<void> addProjectGroup(
      String projectGroupName, List<String> projectIds) {
    final projectGroupData = ProjectGroupData(
      name: projectGroupName,
      projectIds: projectIds,
    );
    return _firestore.collection('project_groups').add(
          projectGroupData.toJson(),
        );
  }

  @override
  Future<void> updateProjectGroup(
      String projectGroupId, String projectGroupName, List<String> projectIds) {
    final projectGroupData = ProjectGroupData(
      name: projectGroupName,
      projectIds: projectIds,
    );
    return _firestore
        .collection('project_groups')
        .document(projectGroupId)
        .updateData(
          projectGroupData.toJson(),
        );
  }

  @override
  Future<void> deleteProjectGroup(String projectGroupId) {
    return _firestore
        .collection('project_groups')
        .document(projectGroupId)
        .delete();
  }
}
