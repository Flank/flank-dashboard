import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides the project group name validation error description
/// based on [ProjectGroupNameValidationErrorCode].
class ProjectGroupNameValidationErrorMessage {
  final ProjectGroupNameValidationErrorCode _code;

  /// Creates the [ProjectGroupNameValidationErrorMessage] with
  /// the given [ProjectGroupNameValidationErrorCode].
  const ProjectGroupNameValidationErrorMessage(this._code);

  /// Provides the project group name validation error message based
  /// on the [ProjectGroupNameValidationErrorCode].
  String get message {
    switch (_code) {
      case ProjectGroupNameValidationErrorCode.isNull:
        return ProjectGroupsStrings.projectGroupNameRequired;
      default:
        return null;
    }
  }
}
