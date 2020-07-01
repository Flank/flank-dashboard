import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';

/// A class that represents the data of the project group to display
/// within dialogs for adding and updating a project group.
class EditProjectGroupDialogViewModel extends ProjectGroupDialogViewModel {
  /// A list of projects' identifiers, related to the group.
  final List<String> selectedProjectIds;

  /// Creates the [EditProjectGroupDialogViewModel].
  ///
  /// The [selectedProjectIds] defaults to an empty list.
  ///
  /// The [selectedProjectIds] must not be null.
  const EditProjectGroupDialogViewModel({
    String id,
    String name,
    this.selectedProjectIds = const [],
  })  : assert(selectedProjectIds != null),
        super(id: id, name: name);
}
