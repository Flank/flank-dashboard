// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_name.dart';
import 'package:metrics/project_groups/presentation/models/project_group_name_validation_error_message.dart';

/// A class for validating a project group name.
class ProjectGroupNameValidator {
  /// Validates the given [value] as a project group name.
  ///
  /// Returns an error message if the given [value] is not a valid project group name.
  /// Otherwise returns `null`.
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
