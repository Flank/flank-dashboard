import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/repositories/project_group_repository.dart';

/// Loads data from [Firestore].
class FirestoreProjectGroupsRepository implements ProjectGroupRepository {
  @override
  Stream<List<ProjectGroup>> projectGroupsStream() {
    // TODO: implement projectGroupsStream
    throw UnimplementedError();
  }

  @override
  Future<void> addProjectGroup(String projectGroupName, List<String> projectIds) {
    // TODO: implement addProjectGroup
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProjectGroup(String projectGroupId) {
    // TODO: implement deleteProjectGroup
    throw UnimplementedError();
  }

  @override
  Future<void> updateProjectGroup(String projectGroupId, String projectGroupName, List<String> projectIds) {
    // TODO: implement updateProjectGroup
    throw UnimplementedError();
  }
}