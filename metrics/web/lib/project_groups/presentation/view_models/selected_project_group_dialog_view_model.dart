/// A class that represents the data of the selected project group to display.
class SelectedProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final List<String> selectedProjectIds;

  /// Creates the [SelectedProjectGroupDialogViewModel].
  SelectedProjectGroupDialogViewModel({
    this.id,
    this.name,
    this.selectedProjectIds,
  });
}
