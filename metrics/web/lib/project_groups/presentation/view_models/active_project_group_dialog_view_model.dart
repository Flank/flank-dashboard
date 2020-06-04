/// Represents the data of the project group that using in UI.
class ActiveProjectGroupDialogViewModel {
  final String id;
  final String name;
  final List<String> selectedProjectIds;

  /// Creates the [ActiveProjectGroupDialogViewModel]
  ///
  /// [id] is the unique identifier of the project group.
  /// [name] is the name of the project group.
  /// [selectedProjectIds] is the list of selected project ids related with
  /// the project group.
  ActiveProjectGroupDialogViewModel({
    this.id,
    this.name,
    this.selectedProjectIds,
  });
}
