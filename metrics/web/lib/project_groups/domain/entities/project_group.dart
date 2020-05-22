import 'package:meta/meta.dart';

/// Represents the project group entity.
@immutable
class ProjectGroup {
  final String id;
  final String name;
  final List<String> projectIds;

  /// Creates the [ProjectGroup] with [id] and [name] and a list of [projectIds].
  const ProjectGroup({
    this.id,
    this.name,
    this.projectIds,
  });
}
