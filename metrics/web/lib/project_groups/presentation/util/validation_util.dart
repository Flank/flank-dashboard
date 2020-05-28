import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_name.dart';
import 'package:metrics/project_groups/presentation/model/project_group_validation_error_message.dart';

class ValidationUtil {
  /// Validates the given [value] as a password.
  ///
  /// Returns an error message if the [value] is not a valid password,
  /// otherwise returns null.
  static String validateProjectGroupName(String value) {
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
