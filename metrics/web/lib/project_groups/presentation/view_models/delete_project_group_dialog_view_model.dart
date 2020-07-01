import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';

/// A class that represents the data of the project group to display
/// within a delete dialog.
class DeleteProjectGroupDialogViewModel extends ProjectGroupDialogViewModel {
  /// Creates the [DeleteProjectGroupDialogViewModel].
  const DeleteProjectGroupDialogViewModel({
    String name,
    String id,
  }) : super(name: name, id: id);
}
