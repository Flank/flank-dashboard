/// Represents the data of the project group that using in project group dialog.
class ActiveProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final List<String> selectedProjectIds;

  /// Creates the [ActiveProjectGroupDialogViewModel].
  ActiveProjectGroupDialogViewModel({
    this.id,
    this.name,
    this.selectedProjectIds,
  });
}
