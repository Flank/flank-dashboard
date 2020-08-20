import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_project_ids.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides an error description based
/// on the [ProjectGroupProjectIdsValidationErrorCode].
class ProjectGroupProjectIdsValidationErrorMessage {
  /// Provides a project group project ids selection error code.
  final ProjectGroupProjectIdsValidationErrorCode _code;

  /// Provides the error message based on the [ProjectGroupProjectIdsValidationErrorCode].
  String get message {
    switch (_code) {
      case ProjectGroupProjectIdsValidationErrorCode.projectsSelectionLimitExceeded:
        return ProjectGroupsStrings.getProjectSelectionError(
          ProjectGroupProjectIds.projectIdsSelectionSizeLimit,
        );
      default:
        return null;
    }
  }

  /// Creates the [ProjectGroupProjectIdsValidationErrorMessage] with
  /// the given [ProjectGroupProjectIdsValidationErrorCode].
  const ProjectGroupProjectIdsValidationErrorMessage(this._code);
}
