class ProjectSelectorViewModel {
  final String id;
  final String name;
  final bool isChecked;

  /// Creates the [ProjectSelectorViewModel]
  ///
  /// [id] is the unique identifier of the project.
  /// [name] is the name of the project.
  /// [isChecked] is the boolean that indicates selecting of this project
  ProjectSelectorViewModel({
    this.id,
    this.name,
    this.isChecked,
  });
}
