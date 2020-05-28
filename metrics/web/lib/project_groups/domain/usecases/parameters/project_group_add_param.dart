import 'package:flutter/cupertino.dart';

/// Represents a param for adding a project group.
@immutable
class ProjectGroupAddParam {
  final String projectGroupName;
  final List<String> projectIds;

  /// Creates the [ProjectGroupAddParam] with the given [projectGroupName]
  /// and [projectIds].
  const ProjectGroupAddParam(
    this.projectGroupName,
    this.projectIds,
  );
}
