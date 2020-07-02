/// A class that represents the data of the project group to display
/// within a delete dialog.
class DeleteProjectGroupDialogViewModel {
  /// A unique identifier of the project.
  final String id;

  /// A name of the project.
  final String name;

  /// Creates the [DeleteProjectGroupDialogViewModel].
  const DeleteProjectGroupDialogViewModel({this.id, this.name});
}
