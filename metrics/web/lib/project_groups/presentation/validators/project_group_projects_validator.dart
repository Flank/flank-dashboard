// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_exception.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_projects.dart';
import 'package:metrics/project_groups/presentation/models/project_group_projects_validation_error_message.dart';

/// A class for validating a project group's projects.
class ProjectGroupProjectsValidator {
  /// Validates the given [value] as a project group project ids.
  ///
  /// Returns an error message if the given [value]
  /// is not a valid project group's projects.
  /// Otherwise returns `null`.
  static String validate(List<String> value) {
    ProjectGroupProjectsValidationErrorMessage errorMessage;

    try {
      ProjectGroupProjects(value);
    } on ProjectGroupProjectsValidationException catch (exception) {
      errorMessage = ProjectGroupProjectsValidationErrorMessage(
        exception.code,
      );
    }

    return errorMessage?.message;
  }
}
