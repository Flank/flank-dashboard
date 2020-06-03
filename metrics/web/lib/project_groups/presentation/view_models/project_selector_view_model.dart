class ProjectSelectorViewModel {
  final String id;
  final String name;
  final bool isChecked;

  /// Creates the [ProjectSelectorViewModel]
  ///
  /// [id] is the unique identifier of the project group.
  /// [name] is the name of the project group.
  /// [isChecked] 
  ProjectSelectorViewModel({
    this.id,
    this.name,
    this.isChecked,
  });
}
