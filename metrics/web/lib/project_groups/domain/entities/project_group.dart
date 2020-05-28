import 'package:meta/meta.dart';

/// Represents the project group entity.
@immutable
class ProjectGroup {
  final String id;
  final String name;
  final List<String> projectIds;

  /// Creates the [ProjectGroup]
  ///
  /// [id] is the unique identifier of this project group.
  /// [name] is the name of this project group.
  /// [projectIds] is the list of project ids related with this project group.
  const ProjectGroup({
    this.id,
    this.name,
    this.projectIds,
  });
}
