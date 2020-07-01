/// A base view model that represents the data of the project group to display
/// within a dialog for a project group.
class ProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Creates the [ProjectGroupDialogViewModel].
  const ProjectGroupDialogViewModel({this.id, this.name});
}
