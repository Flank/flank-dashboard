import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_project_ids_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_project_ids.dart';
import 'package:metrics/project_groups/presentation/models/project_group_project_ids_validation_error_message.dart';

/// A class for validating a project group project ids.
class ProjectGroupProjectIdsValidator {
  /// Validates the given [value] as a project group project ids.
  ///
  /// Returns an error message if the given [value]
  /// is not a valid project group project ids.
  /// Otherwise returns `null`.
  static String validate(List<String> value) {
    ProjectGroupProjectIdsValidationErrorMessage errorMessage;

    try {
      ProjectGroupProjectIds(value);
    } on ProjectGroupProjectIdsValidationException catch (exception) {
      errorMessage = ProjectGroupProjectIdsValidationErrorMessage(
        exception.code,
      );
    }

    return errorMessage?.message;
  }
}
