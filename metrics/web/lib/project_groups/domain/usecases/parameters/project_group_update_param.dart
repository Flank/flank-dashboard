import 'package:flutter/cupertino.dart';

/// Represents a param for editing a project group.
@immutable
class ProjectGroupUpdateParam {
  final String projectGroupId;
  final String projectGroupName;
  final List<String> projectIds;

  /// Creates the [ProjectGroupUpdateParam] with the given [projectGroupId],
  /// [projectGroupName] and [projectIds].
  const ProjectGroupUpdateParam(
    this.projectGroupId,
    this.projectGroupName,
    this.projectIds,
  );
}
