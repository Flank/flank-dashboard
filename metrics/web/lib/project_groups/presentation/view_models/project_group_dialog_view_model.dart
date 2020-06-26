import 'package:meta/meta.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_delete_dialog_view_model.dart';

/// A class that represents the data of the project group to display
/// within a dialog for creating and editing a project group.
class ProjectGroupDialogEditViewModel
    extends ProjectGroupDialogViewModel {
  /// A list of projects' identifiers, related to the group.
  final List<String> selectedProjectIds;

  /// Creates the [ProjectGroupDialogEditViewModel].
  ///
  /// The [selectedProjectIds] defaults to an empty list.
  ///
  /// The [selectedProjectIds] must not be null.
  ProjectGroupDialogEditViewModel({
    @required String id,
    @required String name,
    this.selectedProjectIds = const [],
  })  : assert(selectedProjectIds != null),
        super(id: id, name: name);
}
