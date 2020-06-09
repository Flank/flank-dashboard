import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_name.dart';
import 'package:metrics/project_groups/presentation/model/project_group_validation_error_message.dart';

class ProjectGroupNameValidator {
  /// Validates the given [value] as a project group name.
  ///
  /// Returns an error message if the [value] is not a valid project group name,
  /// otherwise returns null.
  static String validate(String value) {
    ProjectGroupNameValidationErrorMessage errorMessage;

    try {
      ProjectGroupName(value);
    } on ProjectGroupNameValidationException catch (exception) {
      errorMessage = ProjectGroupNameValidationErrorMessage(
        exception.code,
      );
    }

    return errorMessage?.message;
  }
}
