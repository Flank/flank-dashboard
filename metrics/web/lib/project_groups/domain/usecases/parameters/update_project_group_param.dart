import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

/// Represents a param for editing a project group.
@immutable
class UpdateProjectGroupParam extends Equatable {
  final String projectGroupId;
  final String projectGroupName;
  final List<String> projectIds;

  /// Creates the [UpdateProjectGroupParam] with the given [projectGroupId],
  /// [projectGroupName] and [projectIds].
  const UpdateProjectGroupParam(
    this.projectGroupId,
    this.projectGroupName,
    this.projectIds,
  )   : assert(projectGroupId != null),
        assert(projectGroupName != null),
        assert(projectIds != null);

  @override
  List<Object> get props => [projectGroupId, projectGroupName, projectIds];
}
