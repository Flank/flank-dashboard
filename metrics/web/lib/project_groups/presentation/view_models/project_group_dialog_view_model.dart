/// A class that represents the data of the project group to display
/// within dialogs for adding and editing a project group.
class ProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// A list of projects' identifiers, related to the group.
  final List<String> selectedProjectIds;

  /// Creates the [ProjectGroupDialogViewModel].
  ///
  /// The [selectedProjectIds] defaults to an empty list.
  ///
  /// The [selectedProjectIds] must not be null.
  const ProjectGroupDialogViewModel({
    this.id,
    this.name,
    this.selectedProjectIds = const [],
  }) : assert(selectedProjectIds != null);
}
