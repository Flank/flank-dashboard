import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_projects.dart';
import 'package:metrics/project_groups/presentation/models/project_group_projects_validation_error_message.dart';

/// A class for validating a project group project ids.
class ProjectGroupProjectsValidator {
  /// Validates the given [value] as a project group project ids.
  ///
  /// Returns an error message if the given [value]
  /// is not a valid project group project ids.
  /// Otherwise returns `null`.
  static ProjectGroupProjectsValidationErrorMessage validate(List<String> value) {
    ProjectGroupProjectsValidationErrorMessage errorMessage;

    try {
      ProjectGroupProjects(value);
    } on ProjectGroupProjectsValidationException catch (exception) {
      errorMessage = ProjectGroupProjectsValidationErrorMessage(
        exception.code,
      );
    }

    return errorMessage;
  }
}
