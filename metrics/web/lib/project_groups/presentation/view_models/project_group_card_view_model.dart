import 'package:meta/meta.dart';

/// Represents the project group to display.
class ProjectGroupCardViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// The count of projects, related to the group.
  final int projectsCount;

  /// Creates the [ProjectGroupCardViewModel]
  ///
  /// The [id], the [name] and the [projectsCount] must not be null.
  ProjectGroupCardViewModel({
    @required this.id,
    @required this.name,
    @required this.projectsCount,
  })  : assert(id != null),
        assert(name != null),
        assert(projectsCount != null);
}
