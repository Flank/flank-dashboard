import 'package:metrics/project_groups/presentation/view_models/project_selector_view_model.dart';

/// Represents the data of the project group that using in UI.
class ActiveProjectGroupDialogViewModel {
  final String id;
  final String name;
  final List<ProjectSelectorViewModel> projectSelectorViewModels;
  final List<String> projectIds;

  /// Creates the [ActiveProjectGroupDialogViewModel]
  ///
  /// [id] is the unique identifier of the project group.
  /// [name] is the name of the project group.
  /// [projectIds] is the list of project ids related with the project group.
  ActiveProjectGroupDialogViewModel({
    this.id,
    this.name,
    this.projectSelectorViewModels,
    this.projectIds,
  });
}
