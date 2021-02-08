// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/entities/project_group.dart';

/// A base class for project group repositories.
///
/// Provides an ability to get and update the project groups data.
abstract class ProjectGroupRepository {
  /// Provides a stream of [ProjectGroup]s.
  Stream<List<ProjectGroup>> projectGroupsStream();

  /// Provides an ability to add a new project group with
  /// the given [projectGroupName] and [projectIds].
  Future<void> addProjectGroup(
    String projectGroupName,
    List<String> projectIds,
  );

  /// Provides an ability to update a project group's [projectGroupName]
  /// and [projectIds] for a project group with the given [projectGroupId].
  Future<void> updateProjectGroup(
    String projectGroupId,
    String projectGroupName,
    List<String> projectIds,
  );

  /// Provides an ability to delete a project group with the given [projectGroupId].
  Future<void> deleteProjectGroup(String projectGroupId);
}
