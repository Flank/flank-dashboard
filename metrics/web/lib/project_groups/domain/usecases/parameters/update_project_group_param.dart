import 'package:equatable/equatable.dart';

/// Represents a param for editing a project group.
class UpdateProjectGroupParam extends Equatable {
  /// A project group's identifier.
  final String projectGroupId;

  /// A name of the project group.
  final String projectGroupName;

  /// A list of project identifiers, related to the project group.
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
