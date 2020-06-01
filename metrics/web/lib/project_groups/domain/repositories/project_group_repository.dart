import 'package:metrics/project_groups/domain/entities/project_group.dart';

/// Base class for project group repositories.
///
/// Provides an ability to get and manipulate the project groups data.
abstract class ProjectGroupRepository {
  /// Provides the stream of [ProjectGroup]s.
  Stream<List<ProjectGroup>> projectGroupsStream();

  /// Provides the ability to add a project group using a [projectGroupName] and [projectIds].
  Future<void> addProjectGroup(
    String projectGroupName,
    List<String> projectIds,
  );

  /// Provides the ability to update a project group
  /// using a [projectGroupId], a [projectGroupName] and [projectIds].
  Future<void> updateProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  );

  /// Provides the ability to delete a project group by a [projectGroupId].
  Future<void> deleteProjectGroup(String projectGroupId);
}
