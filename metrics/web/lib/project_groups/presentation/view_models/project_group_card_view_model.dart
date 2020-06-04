/// Represents the data of the project group that using in project group card.
class ProjectGroupCardViewModel {
  final String id;
  final String name;
  final int projectsCount;

  /// Creates the [ProjectGroupCardViewModel]
  ///
  /// [id] is the unique identifier of the project group.
  /// [name] is the name of the project group.
  /// [projectsCount] is the count of selected projects related with the project group.
  ProjectGroupCardViewModel({
    this.id,
    this.name,
    this.projectsCount,
  });
}