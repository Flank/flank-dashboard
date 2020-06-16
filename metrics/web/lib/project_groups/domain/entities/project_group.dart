import 'package:meta/meta.dart';

/// Represents the project group entity.
@immutable
class ProjectGroup {
  /// A unique identifier of the project group.
  final String id;

  /// A name of the project group.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final List<String> projectIds;

  /// Creates the [ProjectGroup].
  ///
  /// Throws an ArgumentError if either the [name] or [projectIds] is `null`.
  ProjectGroup({
    this.id,
    @required this.name,
    @required this.projectIds,
  }) {
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(projectIds, 'projectIds');
  }
}
