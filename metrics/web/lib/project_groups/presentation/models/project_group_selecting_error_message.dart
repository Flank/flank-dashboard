import 'package:metrics/project_groups/domain/entities/project_group_selection_error_code.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides an error description based
/// on the [ProjectGroupSelectionErrorCode].
class ProjectGroupSelectionErrorMessage {
  /// Provides a project group selection error code.
  final ProjectGroupSelectionErrorCode _code;

  /// Provides the error message based on the [ProjectGroupSelectionErrorCode].
  String get message {
    switch (_code) {
      case ProjectGroupSelectionErrorCode.selectionError:
        return ProjectGroupsStrings.getProjectSelectionError(
          ProjectGroupsNotifier.maxSelectedProjects,
        );
      default:
        return null;
    }
  }

  /// Creates the [ProjectGroupSelectionErrorMessage] with
  /// the given [ProjectGroupSelectionErrorCode].
  const ProjectGroupSelectionErrorMessage(this._code);
}
