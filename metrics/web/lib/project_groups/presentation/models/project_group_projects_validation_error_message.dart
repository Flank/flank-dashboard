// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_projects_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_projects.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides an error description based
/// on the [ProjectGroupProjectsValidationErrorCode].
class ProjectGroupProjectsValidationErrorMessage {
  /// Provides a project group's projects selection error code.
  final ProjectGroupProjectsValidationErrorCode _code;

  /// Provides the error message based on the [ProjectGroupProjectsValidationErrorCode].
  String get message {
    switch (_code) {
      case ProjectGroupProjectsValidationErrorCode.maxProjectsLimitExceeded:
        final errorMessage = ProjectGroupsStrings.getProjectsLimitExceeded(
          ProjectGroupProjects.maxNumberOfProjects,
        );

        return errorMessage;
      default:
        return null;
    }
  }

  /// Creates the [ProjectGroupProjectsValidationErrorMessage] with
  /// the given [ProjectGroupProjectsValidationErrorCode].
  const ProjectGroupProjectsValidationErrorMessage(this._code);
}
