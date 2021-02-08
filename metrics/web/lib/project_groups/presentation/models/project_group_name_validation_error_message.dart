// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/domain/value_objects/exceptions/project_group_name_validation_error_code.dart';
import 'package:metrics/project_groups/domain/value_objects/project_group_name.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

/// A class that provides the project group name validation error description
/// based on [ProjectGroupNameValidationErrorCode].
class ProjectGroupNameValidationErrorMessage {
  /// Represents error codes of a project group name validation.
  final ProjectGroupNameValidationErrorCode _code;

  /// Provides the project group name validation error message based
  /// on the [ProjectGroupNameValidationErrorCode].
  String get message {
    switch (_code) {
      case ProjectGroupNameValidationErrorCode.isNull:
        return ProjectGroupsStrings.projectGroupNameRequired;
      case ProjectGroupNameValidationErrorCode.charactersLimitExceeded:
        return ProjectGroupsStrings.getProjectGroupNameLimitExceeded(
          ProjectGroupName.charactersLimit,
        );
      default:
        return null;
    }
  }

  /// Creates the [ProjectGroupNameValidationErrorMessage] with
  /// the given [ProjectGroupNameValidationErrorCode].
  const ProjectGroupNameValidationErrorMessage(this._code);
}
