/// A class that represents the data of the project group to display
/// within a delete dialog.
class ProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Creates the [ProjectGroupDialogViewModel].
  const ProjectGroupDialogViewModel({this.name, this.id});
}
